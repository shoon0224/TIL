

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import SnapKit

// MARK: - LocationInformationViewController
/**
 * 편의점 찾기 앱의 메인 화면을 담당하는 ViewController
 * 
 * 역할:
 * - MVVM 패턴에서 View 계층 담당
 * - 지도뷰, 현재위치 버튼, 편의점 리스트 테이블뷰 관리
 * - RxSwift를 통한 ViewModel과의 반응형 바인딩
 * - CoreLocation을 통한 위치 서비스 관리
 * - DaumMap SDK를 통한 지도 기능 제공
 */
class LocationInformationViewController: UIViewController {
    
    // MARK: - Properties
    // RxSwift 메모리 관리를 위한 DisposeBag
    let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    // 위치 서비스를 관리하는 CoreLocation 매니저
    let locationManager = CLLocationManager()
    
    // 다음맵 뷰 (편의점 위치 표시용)
    let mapView = MTMapView()
    
    // 현재 위치로 이동하는 버튼
    let currentLocationButton = UIButton()
    
    // 편의점 목록을 표시하는 테이블뷰
    let detailList = UITableView()
    
    // 편의점 목록이 없을 때 표시되는 배경뷰
    let detailListBackgroundView = DetailListBackgroundView()
    
    // MVVM의 ViewModel (비즈니스 로직과 상태 관리)
    let viewModel = LocationInformationViewModel()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //지도뷰와 위치매니저의 콜백 메서드 처리
        mapView.delegate = self
        locationManager.delegate = self
        
        // ViewModel과의 데이터 바인딩 설정
        bind(viewModel)
        
        // UI 컴포넌트 속성 설정
        attribute()
        
        layout()
    }
    
    // MARK: - ViewModel Binding
    /**
     * ViewModel과 View 간의 양방향 데이터 바인딩을 설정하는 메서드
     * 
     * @param viewModel: 바인딩할 LocationInformationViewModel
     * 
     * 역할:
     * - MVVM 패턴의 핵심인 View-ViewModel 바인딩 구현
     * - RxSwift를 활용한 반응형 프로그래밍 구현
     * - Input(View → ViewModel)과 Output(ViewModel → View) 스트림 연결
     * - 단방향 데이터 플로우 구성
     */
    private func bind(_ viewModel: LocationInformationViewModel) {
        
        // MARK: - 하위 뷰 바인딩
        // 배경뷰를 해당 하위 ViewModel과 바인딩
        detailListBackgroundView.bind(viewModel.detailListBackgroundViewModel)
        
        // MARK: - Output Bindings (ViewModel → View)
        
        /**
         * 지도 중심점 설정 바인딩
         * 
         * 데이터 흐름: ViewModel.setMapCenter → mapView.setMapCenterPoint
         * 
         * RxSwift 핵심 개념:
         * - emit(to:): Signal을 특정 Binder에 연결
         * - mapView.rx.setMapCenterPoint: MTMapView의 Reactive 확장 메서드
         */
        viewModel.setMapCenter
            .emit(to: mapView.rx.setMapCenterPoint)
            .disposed(by: disposeBag)
        
        /**
         * 오류 메시지 표시 바인딩
         * 
         * 데이터 흐름: ViewModel.errorMessage → self.presentAlert
         * 
         * 역할: 네트워크 오류, 위치 오류 등을 사용자에게 알림창으로 표시
         */
        viewModel.errorMessage
            .emit(to: self.rx.presentAlert)
            .disposed(by: disposeBag)
        
        /**
         * 편의점 리스트 테이블뷰 바인딩
         * 
         * 데이터 흐름: ViewModel.detailListCellData → detailList.rx.items
         * 
         * RxSwift 핵심 개념:
         * - drive: Driver를 UI에 바인딩 (테이블뷰 전용)
         * - 클로저 파라미터: (tableView, row, data) → UITableViewCell
         * - 셀 재사용과 데이터 설정을 자동화
         */
        viewModel.detailListCellData
            .drive(detailList.rx.items) { tv, row, data in
                // 재사용 셀 가져오기
                let cell = tv.dequeueReusableCell(withIdentifier: "DetailListCell", for: IndexPath(row: row, section: 0)) as! DetailListCell
                
                // 셀에 데이터 설정
                cell.setData(data)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        /**
         * 지도 POI(Point of Interest) 마커 표시 바인딩
         * 
         * 데이터 흐름: ViewModel.detailListCellData → map transform → self.addPOIItems
         * 
         * 역할:
         * - 편의점 데이터에서 좌표 정보만 추출
         * - 지도에 편의점 위치 마커 표시
         *
         * - map: 데이터 변환 ([DetailListCellData] → [MTMapPoint])
         * - compactMap: Swift 표준 라이브러리 메서드
         *  배열 같은 시퀀스에서 map을 하면서 동시에 nil을 자동으로 걸러줌
         *  즉, 각요소를 변환하고 변환 결과가 nil이면 버림, 변환 결과가 값이면 새로운 배열에 포함
         */
        viewModel.detailListCellData
            .map { $0.compactMap { $0.point} } //cellData에 있는 point 값들을 nil 걸러내고 아래 drive에서
            .drive(self.rx.addPOIItems) //상태 바인딩
            .disposed(by: disposeBag)
        
        /**
         * 선택된 위치로 스크롤 바인딩
         * 
         * 데이터 흐름: ViewModel.scrollToSelectedLocation → self.showSelectedLocation
         * 
         * 역할: 지도에서 마커 선택 시 해당 편의점이 테이블뷰에서 보이도록 스크롤
         */
        viewModel.scrollToSelectedLocation
            .emit(to: self.rx.showSelectedLocation)
            .disposed(by: disposeBag)
        
        // MARK: - Input Bindings (View → ViewModel)
        
        /**
         * 테이블뷰 셀 선택 이벤트 바인딩
         * 
         * 데이터 흐름: detailList.itemSelected → map(row) → ViewModel.detailListItemSelected
         * 
         * 역할:
         * - 사용자가 편의점 리스트에서 특정 항목 선택
         * - 선택된 편의점 위치로 지도 중심점 이동
         * 
         * RxSwift 핵심 개념:
         * - detailList.rx.itemSelected: 테이블뷰 셀 선택 이벤트 스트림
         * - map { $0.row }: IndexPath에서 row 정보만 추출
         * - bind(to:): Observable을 PublishRelay에 연결
         */
        detailList.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.detailListItemSelected)
            .disposed(by: disposeBag)
        
        /**
         * 현재 위치 버튼 탭 이벤트 바인딩
         * 
         * 데이터 흐름: currentLocationButton.tap → ViewModel.curentLocationButtonTapped
         * 
         * 역할: 사용자가 현재 위치 버튼을 탭하면 지도를 현재 위치로 이동
         * 
         * RxSwift 핵심 개념:
         * - currentLocationButton.rx.tap: 버튼 탭 이벤트 스트림
         * - PublishRelay<Void>: 버튼 탭은 값이 없는 이벤트
         */
        currentLocationButton.rx.tap
            .bind(to: viewModel.curentLocationButtonTapped)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Configuration
    /**
     * UI 컴포넌트들의 속성을 설정하는 메서드
     * 
     * 역할:
     * - 네비게이션 타이틀 및 배경색 설정
     * - 지도뷰 위치 추적 모드 설정
     * - 현재 위치 버튼 스타일 구성
     * - 테이블뷰 셀 등록 및 배경뷰 설정
     */
    private func attribute() {
        // 네비게이션 바 타이틀 설정
        title = "내 주변 편의점 찾기"
        
        // 메인 뷰 배경색 설정
        view.backgroundColor = .white
        
        // 지도뷰 위치 추적 모드 설정
        // .onWithoutHeadingWithoutMapMoving: 현재 위치 추적하되 지도는 자동으로 움직이지 않음
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        
        // 현재 위치 버튼 스타일 설정
        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)  // 위치 아이콘
        currentLocationButton.backgroundColor = .white                                        // 흰색 배경
        currentLocationButton.layer.cornerRadius = 20                                        // 둥근 모서리 (40x40 크기의 절반)
        
        // 테이블뷰 설정
        detailList.register(DetailListCell.self, forCellReuseIdentifier: "DetailListCell")   // 커스텀 셀 클래스 등록
        detailList.separatorStyle = .none                                                     // 구분선 제거
        detailList.backgroundView = detailListBackgroundView                                  // 빈 상태 표시용 배경뷰 설정
    }
    
    // MARK: - Layout Configuration
    /**
     * SnapKit을 사용하여 Auto Layout 제약조건을 설정하는 메서드
     * 
     * 역할:
     * - 지도뷰를 화면 상단 영역에 배치
     * - 현재 위치 버튼을 지도뷰 좌측 하단에 배치
     * - 테이블뷰를 화면 하단 영역에 배치
     * - 반응형 레이아웃 구성 (다양한 화면 크기 대응)
     */
    private func layout() {
        // 모든 UI 컴포넌트를 메인 뷰에 추가
        [mapView, currentLocationButton, detailList]
            .forEach { view.addSubview($0) }
        
        // 지도뷰 제약조건 설정
        mapView.snp.makeConstraints {
            // 상단, 좌측, 우측을 Safe Area에 맞춤
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            
            // 하단을 화면 중앙보다 100pt 아래로 설정 (화면의 60% 정도 차지)
            $0.bottom.equalTo(view.snp.centerY).offset(100)
        }
        
        // 현재 위치 버튼 제약조건 설정
        currentLocationButton.snp.makeConstraints {
            // 테이블뷰 상단에서 12pt 위에 배치
            $0.bottom.equalTo(detailList.snp.top).offset(-12)
            
            // 좌측에서 12pt 떨어진 위치
            $0.leading.equalToSuperview().offset(12)
            
            // 정사각형 40x40 크기
            $0.width.height.equalTo(40)
        }
        
        // 테이블뷰 제약조건 설정
        detailList.snp.makeConstraints {
            // 좌우를 화면에 맞춤
            $0.centerX.leading.trailing.equalToSuperview()
            
            // 하단을 Safe Area에서 8pt 위에 배치
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            
            // 상단을 지도뷰 하단과 연결
            $0.top.equalTo(mapView.snp.bottom)
        }
    }
}

// MARK: - CLLocationManagerDelegate
/**
 * CoreLocation의 위치 서비스 이벤트를 처리하는 Delegate 확장
 * 
 * 역할:
 * - 위치 권한 상태 변화 감지 및 처리
 * - 위치 권한 거부 시 적절한 오류 메시지 전달
 * - 사용자 프라이버시 보호를 위한 권한 관리
 */
extension LocationInformationViewController: CLLocationManagerDelegate {
    
    /**
     * 위치 권한 상태가 변경될 때 호출되는 메서드
     * 
     * @param manager: 위치 매니저 인스턴스
     * @param status: 변경된 권한 상태
     * 
     * 역할:
     * - 위치 권한 허용 여부 확인
     * - 권한 거부 시 사용자에게 알림 제공
     * - ViewModel에 오류 상태 전달
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,          // 항상 허용
             .authorizedWhenInUse,       // 앱 사용 중 허용
             .notDetermined:             // 아직 결정되지 않음
            // 정상적인 상태이므로 별도 처리 불필요
            return
        default:
            // 권한 거부 등 오류 상황 시 ViewModel에 에러 전달
            viewModel.mapViewError.accept(MTMapViewError.locationAuthorizaationDenied.errorDescription)
            return
        }
    }
}

// MARK: - MTMapViewDelegate
/**
 * DaumMap의 지도뷰 이벤트를 처리하는 Delegate 확장
 * 
 * 역할:
 * - 현재 위치 업데이트 이벤트 처리
 * - 지도 이동 완료 이벤트 처리
 * - 지도 마커(POI) 선택 이벤트 처리
 * - 위치 업데이트 실패 이벤트 처리
 */
extension LocationInformationViewController: MTMapViewDelegate {
    
    /**
     * 현재 위치가 업데이트될 때 호출되는 메서드
     * 
     * @param mapView: 지도뷰 인스턴스
     * @param location: 업데이트된 현재 위치
     * @param accuracy: 위치 정확도
     * 
     * 역할:
     * - GPS에서 받은 현재 위치를 ViewModel에 전달
     * - 디버그 모드에서는 고정된 테스트 좌표 사용 (서울 강남구)
     * - 릴리즈 모드에서는 실제 GPS 위치 사용
     */
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        #if DEBUG
        // 디버그 모드: 테스트용 고정 좌표 (서울 강남구 일대)
        viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.110341)))
        #else
        // 릴리즈 모드: 실제 GPS 위치 사용
        viewModel.currentLocation.accept(location)
        #endif
    }
    
    /**
     * 지도 이동 애니메이션이 완료된 후 호출되는 메서드
     * 
     * @param mapView: 지도뷰 인스턴스
     * @param mapCenterPoint: 이동 완료된 지도 중심점
     * 
     * 역할:
     * - 사용자가 지도를 드래그하여 이동시킨 후 새로운 중심점을 ViewModel에 전달
     * - 새로운 위치 기준으로 편의점 재검색 트리거
     */
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    /**
     * 지도에서 POI(편의점 마커)가 선택될 때 호출되는 메서드
     * 
     * @param mapView: 지도뷰 인스턴스
     * @param poiItem: 선택된 POI 아이템
     * @return Bool: false 반환 (기본 선택 동작 수행하지 않음)
     * 
     * 역할:
     * - 사용자가 지도의 편의점 마커를 탭했을 때 해당 정보를 ViewModel에 전달
     * - 선택된 편의점에 맞는 리스트 아이템으로 스크롤 트리거
     */
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        viewModel.selectPOIItem.accept(poiItem)
        return false
    }
    
    /**
     * 현재 위치 업데이트가 실패했을 때 호출되는 메서드
     * 
     * @param mapView: 지도뷰 인스턴스
     * @param error: 발생한 오류
     * 
     * 역할:
     * - GPS 신호 약함, 네트워크 오류 등으로 위치 업데이트 실패 시 처리
     * - 오류 메시지를 ViewModel에 전달하여 사용자에게 알림
     */
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
        viewModel.mapViewError.accept(error.localizedDescription)
    }
}

// MARK: - RxSwift Extensions

/**
 * MTMapView의 RxSwift 확장
 * 
 * 역할:
 * - DaumMap의 MTMapView를 RxSwift와 호환되도록 확장
 * - ViewModel에서 지도 조작을 위한 Binder 제공
 * - 반응형 프로그래밍 패턴과 기존 SDK 연결
 */
extension Reactive where Base: MTMapView {
    
    /**
     * 지도 중심점을 설정하는 Binder
     * 
     * 역할:
     * - ViewModel의 Signal/Driver를 지도뷰의 중심점 변경과 연결
     * - 애니메이션과 함께 부드러운 지도 이동 제공
     * 
     * RxSwift 핵심 개념:
     * - Binder: UI 업데이트를 위한 Observer (에러 무시, 메인스레드 보장)
     * - 클로저 파라미터: (지도뷰, 새로운 중심점)
     */
    var setMapCenterPoint: Binder<MTMapPoint> {
        return Binder(base) { base, point in
            // 애니메이션과 함께 지도 중심점 이동
            base.setMapCenter(point, animated: true)
        }
    }
}

/**
 * LocationInformationViewController의 RxSwift 확장
 * 
 * 역할:
 * - ViewController의 UI 동작들을 RxSwift Binder로 노출
 * - ViewModel에서 View의 동작을 제어할 수 있도록 인터페이스 제공
 * - MVVM 패턴의 View-ViewModel 바인딩 지원
 */
extension Reactive where Base: LocationInformationViewController {
    
    /**
     * 알림창을 표시하는 Binder
     * 
     * @param String: 표시할 오류 메시지
     * 
     * 역할:
     * - ViewModel의 오류 메시지를 알림창으로 사용자에게 표시
     * - 네트워크 오류, 위치 오류 등 다양한 오류 상황 처리
     */
    var presentAlert: Binder<String> {
        return Binder(base) { base, message in
            // 알림창 구성
            let alertController = UIAlertController(
                title: "문제가 발생했어요", 
                message: message, 
                preferredStyle: .alert
            )
            
            // 확인 버튼 추가
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(action)
            
            // 알림창 표시
            base.present(alertController, animated: true, completion: nil)
        }
    }
    
    /**
     * 선택된 편의점 위치로 테이블뷰 스크롤하는 Binder
     * 
     * @param Int: 스크롤할 row 인덱스
     * 
     * 역할:
     * - 지도에서 마커 선택 시 해당 편의점이 리스트에서 보이도록 스크롤
     * - 지도와 리스트 간의 동기화 제공
     */
    var showSelectedLocation: Binder<Int> {
        return Binder(base) { base, row in
            // IndexPath 생성 (section 0, 해당 row)
            let indexPath = IndexPath(row: row, section: 0)
            
            // 해당 셀로 애니메이션과 함께 스크롤하고 선택 상태로 표시
            base.detailList.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        }
    }
    
    /**
     * 지도에 편의점 마커들을 추가하는 Binder
     * 
     * @param [MTMapPoint]: 표시할 편의점 위치들의 배열
     * 
     * 역할:
     * - 편의점 데이터를 받아 지도에 빨간 핀 마커로 표시
     * - 기존 마커 제거 후 새로운 마커들 추가
     * - 마커와 리스트 아이템 간 연결을 위한 tag 설정
     */
    var addPOIItems: Binder<[MTMapPoint]> {
        return Binder(base) { base, points in
            // 좌표 배열을 POI 아이템 배열로 변환
            let items = points
                .enumerated()  // (인덱스, 좌표) 튜플로 변환
                .map { offset, point -> MTMapPOIItem in
                    // 새로운 POI 아이템 생성
                    let mapPOIItem = MTMapPOIItem()
                    
                    mapPOIItem.mapPoint = point                           // 좌표 설정
                    mapPOIItem.markerType = .redPin                       // 빨간 핀 마커
                    mapPOIItem.showAnimationType = .springFromGround      // 땅에서 튀어나오는 애니메이션
                    mapPOIItem.tag = offset                               // 리스트 인덱스와 연결을 위한 태그
                    
                    return mapPOIItem
                }
            
            // 기존 모든 POI 아이템 제거
            base.mapView.removeAllPOIItems()
            
            // 새로운 POI 아이템들 추가
            base.mapView.addPOIItems(items)
        }
    }
}
