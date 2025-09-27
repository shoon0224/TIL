

import Foundation

// MARK: - KLDocument (Kakao Local Document)
/**
 * 카카오 로컬 API에서 반환하는 개별 장소 정보 모델
 * 
 * 역할:
 * - 카카오 로컬 API 응답의 documents 배열 내 각 항목을 나타내는 모델
 * - JSON의 snake_case를 Swift의 camelCase로 매핑
 * - 장소의 기본 정보(이름, 주소, 좌표, 거리)를 담는 데이터 구조
 */
struct KLDocument: Decodable {
    // 장소명 (예: "세븐일레븐 강남점")
    let placeName: String
    
    // 지번 주소 (예: "서울 강남구 역삼동 123-45")
    let addressName: String
    
    // 도로명 주소 (예: "서울 강남구 테헤란로 123")
    let roadAddressName: String
    
    // 경도 (longitude) - 동서 방향 좌표
    let x: String
    
    // 위도 (latitude) - 남북 방향 좌표
    let y: String
    
    // 현재 위치로부터의 거리 (미터 단위)
    let distance: String
    
    // MARK: - CodingKeys
    /**
     * JSON의 키명과 Swift 프로퍼티명 매핑을 위한 열거형
     * 
     * 역할:
     * - API 응답의 snake_case(place_name) → Swift camelCase(placeName) 자동 변환
     * - Decodable 프로토콜이 이 매핑 정보를 사용하여 JSON 파싱
     */
    enum CodingKeys: String, CodingKey {
        // 동일한 이름은 생략 가능 (x, y, distance)
        case x, y, distance
        
        // 다른 이름은 명시적으로 매핑
        case placeName = "place_name"           // place_name → placeName
        case addressName = "address_name"       // address_name → addressName  
        case roadAddressName = "road_address_name" // road_address_name → roadAddressName
    }
}
