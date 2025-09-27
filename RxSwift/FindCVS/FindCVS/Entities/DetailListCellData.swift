

import Foundation

// MARK: - DetailListCellData
/**
 * 상세 리스트 테이블뷰 셀에 표시할 데이터 모델
 * 
 * 역할:
 * - KLDocument(API 응답 모델)을 UI 표시용 데이터로 변환한 중간 모델
 * - 테이블뷰 셀이 필요로 하는 정보만 추출하여 담는 ViewModel 성격의 데이터 구조
 * - MVVM 패턴에서 View와 Model 사이의 데이터 변환 계층 역할
 */
struct DetailListCellData {
    // 편의점명 등 장소 이름 (UI 표시용)
    let placeName: String
    
    // 표시할 주소 (도로명 또는 지번 주소 중 선택된 것)
    let address: String
    
    // 현재 위치로부터의 거리 (UI 표시용 포맷팅된 문자열)
    let distance: String
    
    // 지도에 표시할 좌표 포인트 (DaumMap용 MTMapPoint 객체)
    // 이 포인트를 통해 지도에 핀(마커) 표시 가능
    let point: MTMapPoint
}
