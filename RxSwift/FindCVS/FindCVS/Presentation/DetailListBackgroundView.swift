

import UIKit
import RxSwift
import RxCocoa

// MARK: - DetailListBackgroundView
/**
 * 편의점 리스트 테이블뷰의 배경 뷰 클래스
 * 
 * 역할:
 * - 편의점 검색 결과가 없을 때 표시되는 상태 표시 뷰
 * - RxSwift를 사용한 ViewModel과의 반응형 바인딩
 * - MVVM 패턴에서 View 계층 담당
 * - 사용자에게 현재 상태를 시각적으로 전달
 */
class DetailListBackgroundView: UIView {
    
    // MARK: - Properties
    // RxSwift 메모리 관리를 위한 DisposeBag
    let disposeBag = DisposeBag()
    
    // 상태를 표시하는 라벨 (편의점 이모지 표시)
    let statusLabel = UILabel()
    
    // MARK: - Initializers
    /**
     * @param frame: 뷰의 초기 프레임 (Auto Layout 사용 시 무시됨)
     * 
     * 역할:
     * - UI 컴포넌트 속성 설정
     * - Auto Layout 제약조건 설정
     * - 테이블뷰 배경뷰로 사용할 준비
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // UI 속성 설정
        attribute()
        
        // Auto Layout 제약조건 설정
        layout()
    }
    
    /**
     * 스토리보드에서 뷰를 생성할 때 호출되는 초기화 메서드
     * 
     * 역할:
     * - 현재 프로젝트에서는 코드로만 UI를 구성하므로 사용하지 않음
     * - fatalError로 스토리보드 사용 시도를 차단
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewModel Binding
    /**
     * ViewModel과의 데이터 바인딩을 설정하는 메서드
     * 
     * @param viewModel: 바인딩할 DetailListBackgroundViewModel
     * 
     * 역할:
     * - ViewModel의 출력 스트림을 View의 UI 요소에 연결
     * - RxSwift의 반응형 프로그래밍 구현
     * - MVVM 패턴의 View-ViewModel 바인딩 계층
     * 
     * RxSwift 핵심 개념:
     * - emit(to:): Signal을 UI 프로퍼티에 바인딩
     * - statusLabel.rx.isHidden: UILabel의 isHidden 프로퍼티를 Reactive 확장
     * - disposed(by:): 메모리 누수 방지를 위한 구독 해제 관리
     */
    func bind(_ viewModel: DetailListBackgroundViewModel) {
        /**
         * 상태 라벨의 표시/숨김 상태를 ViewModel과 연결
         * 
         * 데이터 흐름:
         * 1. ViewModel에서 편의점 검색 결과 유무 판단
         * 2. isStatusLabelHidden Signal 방출
         * 3. statusLabel.isHidden 프로퍼티에 자동 반영
         * 
         * 결과:
         * - 편의점이 있으면: 라벨 숨김 (리스트 표시)
         * - 편의점이 없으면: 라벨 표시 (빈 상태 알림)
         */
        viewModel.isStatusLabelHidden
            .emit(to: statusLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Configuration
    /**
     * - 사용자 친화적인 빈 상태 UI 제공
     */
    private func attribute() {
        backgroundColor = .white
        statusLabel.text = "🏪"
        
        // 텍스트 중앙 정렬
        statusLabel.textAlignment = .center
    }
    
    // MARK: - Layout Configuration
    /**
     * SnapKit을 사용하여 Auto Layout 제약조건을 설정하는 메서드
     * 
     * 역할:
     * - 상태 라벨을 화면 중앙에 배치
     * - 좌우 여백을 통한 반응형 레이아웃 구성
     */
    private func layout() {
        // 상태 라벨을 뷰에 추가
        addSubview(statusLabel)
        
        // 상태 라벨 제약조건 설정
        statusLabel.snp.makeConstraints {
            // 뷰의 정중앙에 배치
            $0.center.equalToSuperview()
            
            // 좌우 20pt 여백 확보 (긴 텍스트 대응)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
