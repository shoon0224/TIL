

import UIKit

// MARK: - DetailListCell
/**
 * 편의점 정보를 표시하는 테이블뷰 셀 클래스
 * 
 * 역할:
 * - 편의점 이름, 주소, 거리 정보를 UI로 표시
 * - SnapKit을 사용한 Auto Layout 구성
 * - MVVM 패턴에서 View 계층 담당
 * - UITableViewCell의 재사용성 활용
 */
class DetailListCell: UITableViewCell {
    
    // MARK: - UI Components
    // 편의점 이름을 표시하는 라벨 (볼드체, 16pt)
    let placeNameLabel = UILabel()
    
    // 편의점 주소를 표시하는 라벨 (회색, 14pt)
    let addressLabel = UILabel()
    
    // 현재 위치로부터의 거리를 표시하는 라벨 (진회색, 12pt)
    let distanceLabel = UILabel()
    
    // MARK: - Initializers
    /**
     * 프로그래밍 방식으로 셀을 생성할 때 호출되는 초기화 메서드
     * 
     * @param style: 셀 스타일 (사용하지 않음, 커스텀 UI 구성)
     * @param reuseIdentifier: 셀 재사용 식별자
     * 
     * 역할:
     * - UI 컴포넌트 속성 설정
     * - Auto Layout 제약조건 설정
     * - UITableView의 셀 재사용 매커니즘과 연동
     */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // UI 속성 설정
        attribute()
        
        // Auto Layout 제약조건 설정
        layout()
    }
    
    /**
     * 스토리보드에서 셀을 생성할 때 호출되는 초기화 메서드
     * 
     * 역할:
     * - 현재 프로젝트에서는 코드로만 UI를 구성하므로 사용하지 않음
     * - fatalError로 스토리보드 사용 시도를 차단
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data Binding
    /**
     * 셀에 데이터를 설정하는 메서드
     * 
     * @param data: 표시할 편의점 정보 (DetailListCellData)
     * 
     * 역할:
     * - ViewModel에서 전달받은 데이터를 UI에 반영
     * - 각 라벨에 해당하는 텍스트 설정
     * - 데이터 바인딩의 View 계층 역할
     */
    func setData(_ data: DetailListCellData) {
        // 편의점 이름 설정
        placeNameLabel.text = data.placeName
        
        // 편의점 주소 설정 (도로명 주소 우선)
        addressLabel.text = data.address
        
        // 거리 정보 설정 (예: "123m")
        distanceLabel.text = data.distance
    }
    
    // MARK: - UI Configuration
    /**
     * UI 컴포넌트들의 속성을 설정하는 메서드
     * 
     * 역할:
     * - 폰트, 색상, 배경색 등 UI 스타일 정의
     * - 디자인 시스템에 맞는 일관된 스타일 적용
     */
    private func attribute() {
        // 셀 배경색 설정
        backgroundColor = .white
        
        // 편의점 이름 라벨 스타일 (강조용 볼드체)
        placeNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        // 주소 라벨 스타일 (보조 정보용 회색)
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.textColor = .gray
        
        // 거리 라벨 스타일 (작은 텍스트, 진회색)
        distanceLabel.font = .systemFont(ofSize: 12, weight: .light)
        distanceLabel.textColor = .darkGray
    }
    
    // MARK: - Layout Configuration
    /**
     * SnapKit을 사용하여 Auto Layout 제약조건을 설정하는 메서드
     * 
     * 역할:
     * - 각 UI 컴포넌트의 위치와 크기 정의
     * - 반응형 UI 구성 (다양한 화면 크기 대응)
     * - 가독성 좋은 레이아웃 구조 제공
     */
    private func layout() {
        // 모든 라벨을 contentView에 추가
        [placeNameLabel, addressLabel, distanceLabel]
            .forEach { contentView.addSubview($0) }
        
        // 편의점 이름 라벨 제약조건
        // 셀 상단에서 12pt 떨어진 위치, 좌측에서 18pt 떨어진 위치
        placeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(18)
        }
        
        // 주소 라벨 제약조건
        // 편의점 이름 아래 3pt, 같은 좌측 정렬, 하단 여백 12pt
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(placeNameLabel)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        // 거리 라벨 제약조건
        // 셀 중앙 수직 정렬, 우측에서 20pt 떨어진 위치
        distanceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
