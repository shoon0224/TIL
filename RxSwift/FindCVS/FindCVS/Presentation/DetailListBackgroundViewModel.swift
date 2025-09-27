

import RxSwift
import RxCocoa

// MARK: - DetailListBackgroundViewModel
/**
 * 편의점 리스트 배경 뷰의 상태를 관리하는 간단한 ViewModel
 * 
 * 역할:
 * - 편의점 검색 결과 유무에 따른 상태 라벨 표시/숨김 제어
 * - 부모 ViewModel(LocationInformationViewModel)과의 통신
 * - MVVM 패턴에서 하위 컴포넌트의 ViewModel 역할
 * - 단순한 상태 관리 예시 (복잡한 로직 없음)
 */
struct DetailListBackgroundViewModel {
    // MARK: - Output (ViewModel → View)
    /**
     * 상태 라벨의 표시/숨김 여부를 전달하는 Signal
     * 
     * RxSwift 핵심 개념:
     * - Signal: UI 바인딩에 최적화된 스트림 (메인스레드, 에러 없음)
     */
    let isStatusLabelHidden: Signal<Bool>
    
    // MARK: - Input (External → ViewModel)
    /**
     * 외부(부모 ViewModel)에서 전달받는 상태 라벨 제어 명령
     * 
     * RxSwift 핵심 개념:
     * - PublishSubject: 외부에서 값을 주입할 수 있는 스트림
     * - 부모-자식 ViewModel 간 통신 수단
     */
    let shouldHideStatusLabel = PublishSubject<Bool>()
    
    // MARK: - Initializer
    /**
     * DetailListBackgroundViewModel 초기화
     * 
     * 역할:
     * - Input과 Output 스트림 연결
     * - 단순한 변환 로직 (PublishSubject → Signal)
     * - 에러 발생 시 기본값(true)으로 대체하여 UI 안정성 확보
     */
    init() {
        /**
         * 입력 스트림을 출력 스트림으로 변환
         * 
         * RxSwift 핵심 개념:
         * - asSignal: Subject를 UI 바인딩용 Signal로 변환
         * - onErrorJustReturn: 에러 시 기본값 반환 (true = 라벨 숨김)
         */
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true)
    }
}
