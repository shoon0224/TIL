

import Foundation

// MARK: - MTMapViewError
/**
 * 지도(MTMapView) 관련 에러를 정의한 열거형
 * 
 * 역할:
 * - 지도 기능에서 발생할 수 있는 오류 상황을 타입 세이프하게 정의
 * - Error 프로토콜을 채택하여 Swift의 에러 처리 시스템과 연동
 * - 사용자에게 표시할 친화적인 오류 메시지 제공
 * - MVVM 패턴에서 Model 계층의 오류 정의 역할
 */
enum MTMapViewError: Error {
    // 현재 위치 업데이트 실패 케이스
    case failedUpdatingCurrentLocation
    
    // 위치 권한 거부 케이스
    case locationAuthorizaationDenied
    
    // MARK: - Error Description
    /**
     * 각 에러 케이스에 대응하는 사용자 친화적 메시지를 반환하는 계산 프로퍼티
     * 
     * 역할:
     * - 개발자용 에러 코드를 사용자가 이해할 수 있는 메시지로 변환
     * - UI에서 사용자에게 표시할 오류 메시지 제공
     * - 다국어 지원 시 이 부분을 수정하여 지역화 가능
     */
    var errorDescription: String {
        switch self {
        case .failedUpdatingCurrentLocation:
            // GPS나 네트워크 문제로 위치 정보를 가져올 수 없을 때
            return "현재 위치를 불러오지 못했어요. 잠시 후 다시 시도해주세요."
            
        case .locationAuthorizaationDenied:
            // 사용자가 위치 권한을 거부했을 때
            return "위치 정보를 비활성화하면 사용자의 현재 위치를 알 수 없어요."
        }
    }
}
