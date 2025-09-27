

import Foundation

// MARK: - LocationData
/**
 * 카카오 로컬 API 응답의 최상위 데이터 모델
 * 
 * 역할:
 * - 카카오 로컬 API에서 받은 JSON 응답을 Swift 객체로 변환하기 위한 모델
 * - Decodable 프로토콜을 채택하여 JSON → Swift 객체 자동 변환 지원
 * - MVVM 패턴에서 Model 계층에 해당
 */
struct LocationData: Decodable {
    // 카카오 로컬 API 응답 중 "documents" 배열을 담는 프로퍼티
    // 검색된 장소들의 목록을 포함 (편의점, 카페 등)
    let documents: [KLDocument]
}
