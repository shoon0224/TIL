

import RxSwift
import RxCocoa

/**
 * - View의 입력을 받아 Model에 전달하고, Model의 결과를 View에 전달
 * - 테스트 가능한 상태 관리
 */
struct LocationInformationViewModel {
    // RxSwift 메모리 관리를 위한 DisposeBag
    let disposeBag = DisposeBag()
    
    // MARK: - Sub ViewModels
    // 하위 뷰모델들 (컴포지션 패턴)
    let detailListBackgroundViewModel = DetailListBackgroundViewModel()
    
    // MARK: - Output (ViewModel → View)
    /**
     * ViewModel에서 View로 전달하는 데이터 스트림들
     * 
     * RxSwift 핵심 개념:
     * - Signal: UI 바인딩용 스트림 (메인스레드, 에러 없음, 공유됨)
     * - Driver: TableView/CollectionView 바인딩용 (메인스레드, 에러 없음, 상태 유지)
     */
    
    // 지도 중심점 설정 신호
    let setMapCenter: Signal<MTMapPoint>
    
    // 오류 메시지 표시 신호
    let errorMessage: Signal<String>
    
    // 테이블뷰에 표시할 편의점 데이터
    let detailListCellData: Driver<[DetailListCellData]>
    
    // 선택된 위치로 스크롤 신호
    let scrollToSelectedLocation: Signal<Int>
    
    // MARK: - Input (View → ViewModel)
    /**
     * View에서 ViewModel로 전달하는 이벤트 스트림들
     * 
     * RxSwift 핵심 개념:
     * - PublishRelay: 에러 없이 값만 전달하는 Subject (UI 이벤트에 적합)
     */
    
    // 현재 위치 좌표 (GPS에서 받은 위치)
    let currentLocation = PublishRelay<MTMapPoint>()
    
    // 지도 중심점 변경 이벤트 (사용자가 지도를 드래그했을 때)
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    
    // 지도 POI(Point of Interest) 선택 이벤트
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    
    // 지도 관련 오류 이벤트
    let mapViewError = PublishRelay<String>()
    
    // 현재 위치 버튼 탭 이벤트
    let curentLocationButtonTapped = PublishRelay<Void>()
    
    // 상세 리스트 아이템 선택 이벤트
    let detailListItemSelected = PublishRelay<Int>()
    
    // MARK: - Private Properties
    // 내부적으로 사용하는 편의점 문서 데이터 스트림
    private let documentData = PublishSubject<[KLDocument]>()
    
    // MARK: - Initializer
    /**
     * LocationInformationViewModel 초기화 및 RxSwift 스트림 구성
     * 
     * @param model: 비즈니스 로직을 담당하는 Model (의존성 주입)
     * 
     * 역할:
     * - 모든 RxSwift 스트림의 연결과 바인딩 설정
     * - Input과 Output 스트림 간의 데이터 흐름 정의
     * - 반응형 프로그래밍의 선언적 구조 구축
     */
    init(model: LocationInformationModel = LocationInformationModel()) {
        
        // MARK: - 네트워크 통신으로 데이터 불러오기
        /**
         * 지도 중심점이 변경될 때마다 해당 위치 기준으로 편의점 검색
         * 
         * RxSwift 핵심 개념:
         * - flatMapLatest: 새로운 이벤트가 들어오면 이전 요청 취소하고 최신 요청만 처리
         * - share: 여러 구독자가 같은 스트림을 공유 (네트워크 요청 중복 방지)
         */
        let cvsLocationDataResult = mapCenterPoint
            .flatMapLatest(model.getLocation)
            .share()
        
        /**
         * 네트워크 요청 성공 케이스만 필터링하여 LocationData 추출
         * 
         * RxSwift 핵심 개념:
         * - compactMap: 변환과 동시에 nil 값 필터링
         * - guard case let: Result 타입의 success 케이스만 추출
         */
        let cvsLocationDataValue = cvsLocationDataResult
            .compactMap { data -> LocationData? in
                guard case let .success(value) = data else {
                    return nil
                }
                return value
            }
        
        /**
         * 네트워크 요청 실패 및 빈 결과에 대한 오류 메시지 생성
         * 
         * 오류 처리 로직:
         * - 성공했지만 검색 결과가 없는 경우
         * - 네트워크 오류 등 실패한 경우
         */
        let cvsLocationDataErrorMessage = cvsLocationDataResult
            .compactMap { data -> String? in
                switch data {
                case let .success(data) where data.documents.isEmpty:
                    // 검색 결과가 없을 때 사용자 친화적 메시지
                    return """
                    500m 근처에 이용할 수 있는 편의점이 없어요.
                    지도 위치를 옮겨서 재검색해주세요.
                    """
                case let .failure(error):
                    // 네트워크 오류 등의 경우
                    return error.localizedDescription
                default:
                    // 성공적으로 데이터를 받은 경우 (nil 반환으로 오류 없음을 의미)
                    return nil
                }
            }
        
        /**
         * 성공적으로 받은 편의점 데이터를 내부 스트림에 바인딩
         * 
         * RxSwift 핵심 개념:
         * - map: 데이터 변환 (LocationData → [KLDocument])
         * - bind(to:): 스트림을 다른 스트림에 연결
         * - disposed(by:): 메모리 누수 방지를 위한 구독 해제 관리
         */
        cvsLocationDataValue
            .map { $0.documents }
            .bind(to: documentData)
            .disposed(by: disposeBag)
        
        // MARK: - 지도 중심점 설정
        /**
         * 상세 리스트에서 선택된 편의점의 좌표 추출
         *
         * - withLatestFrom: 두 개의 Observable을 다룰 때 쓰는 연산자
         * - 트리거 Observable: 앞쪽에 쓰인 Observable (`detailListItemSelected`)
         * - 참조 Observable: `withLatestFrom()` 안에 들어간 Observable (`documentData`)
         *
         * 1. 트리거 Observable이 이벤트를 방출해야 실행됨
         * 2. 그 순간 참조 Observable의 가장 최근(latest) 값을 가져옴
         * 3. 클로저 `{ $1[$0] }`에서
         *    - `$0`: 선택된 인덱스(row)
         *    - `$1`: 최신 문서 배열
         *    - `$1[$0]`: 선택된 인덱스에 해당하는 Document 추출
         */
        let selectDetailListItem = detailListItemSelected
            .withLatestFrom(documentData) { $1[$0] }
            .map(model.documentToMTMapPoint)
        
        /**
         * 현재 위치 버튼 탭 시 현재 위치 좌표 반환
         * 
         * RxSwift 핵심 개념:
         * - withLatestFrom: 버튼 탭 이벤트와 현재 위치를 결합
         */
        let moveToCurrentLocation = curentLocationButtonTapped
            .withLatestFrom(currentLocation)
        
        /**
         * 지도 중심점을 변경하는 모든 이벤트들을 통합
         * 
         * 지도 중심점 변경 시나리오:
         * 1. 리스트에서 편의점 선택
         * 2. 앱 최초 실행 시 현재 위치 (take(1)로 한 번만)
         * 3. 현재 위치 버튼 탭
         * 
         * RxSwift 핵심 개념:
         * - Observable.merge: 여러 스트림을 하나로 병합
         * - take(1): 첫 번째 값만 가져오고 완료
         */
        let currentMapCenter = Observable
            .merge(
                selectDetailListItem,
                currentLocation.take(1),
                moveToCurrentLocation
            )
        
        // MARK: - Output 스트림 연결
        /**
         * 지도 중심점 설정 Signal 생성
         * 
         * RxSwift 핵심 개념:
         * - asSignal: Observable을 Signal로 변환 (UI 바인딩용)
         * - onErrorSignalWith: 에러 발생 시 빈 Signal로 대체
         */
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        /**
         * 오류 메시지 Signal 생성 (네트워크 오류 + 지도 오류 통합)
         * 
         * RxSwift 핵심 개념:
         * - Observable.merge: 두 종류의 오류를 하나의 스트림으로 통합
         * - asSignal: 에러 시 기본 메시지로 대체
         */
        errorMessage = Observable
            .merge(
                cvsLocationDataErrorMessage,
                mapViewError.asObservable()
            )
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요.")
        
        /**
         * 테이블뷰용 편의점 데이터 Driver 생성
         * 
         * RxSwift 핵심 개념:
         * - asDriver: Observable을 Driver로 변환 (테이블뷰 바인딩용)
         * - onErrorDriveWith: 에러 시 빈 배열로 대체
         */
        detailListCellData = documentData
            .map(model.documentsToCellData)
            .asDriver(onErrorDriveWith: .empty())
        
        /**
         * 편의점 데이터 유무에 따른 배경 상태 라벨 표시 제어
         * 
         * 로직:
         * - 편의점 데이터가 있으면 상태 라벨 숨김 (true)
         * - 편의점 데이터가 없으면 상태 라벨 표시 (false)
         */
        documentData
            .map { !$0.isEmpty }
            .bind(to: detailListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)
        
        /**
         * 지도에서 POI 선택 시 해당 리스트 아이템으로 스크롤
         * 
         * RxSwift 핵심 개념:
         * - map: POI의 tag 속성을 인덱스로 사용
         * - tag: 지도 마커와 리스트 아이템을 연결하는 식별자
         */
        scrollToSelectedLocation = selectPOIItem
            .map { $0.tag }
            .asSignal(onErrorJustReturn: 0)
    }
}
