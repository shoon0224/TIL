

import Foundation

// MARK: - LocalAPI
/**
 * 카카오 로컬 API 호출을 위한 URL 구성 클래스
 * 
 * 역할:
 * - 카카오 로컬 API의 기본 정보(스키마, 호스트, 경로)를 관리
 * - 검색 조건에 따른 완전한 URL을 생성
 * - 네트워크 요청 URL의 일관성 보장
 * - MVVM 패턴에서 Model 계층의 API 설정 역할
 */
struct LocalAPI {
    // API의 프로토콜 (HTTPS 사용)
    static let scheme = "https"
    
    // 카카오 개발자 API 서버 주소
    static let host = "dapi.kakao.com"
    
    // 카테고리별 장소 검색 API 엔드포인트
    static let path = "/v2/local/search/category.json"
    
    // MARK: - getLocation
    /**
     * 주어진 좌표 기준으로 편의점 검색 URL을 생성하는 메서드
     * 
     * @param mapPoint: 검색 기준이 되는 지도 좌표
     * @return URLComponents: 완성된 URL 컴포넌트 객체
     * 
     * 역할:
     * - 지도 좌표를 기준으로 반경 500m 내 편의점 검색 URL 생성
     * - 쿼리 파라미터를 체계적으로 구성
     * - URL 안전성 보장 (URLComponents 사용)
     */
    func getLocation(by mapPoint: MTMapPoint) -> URLComponents {
        // URLComponents를 사용하여 안전한 URL 구성
        var components = URLComponents()
        components.scheme = LocalAPI.scheme      // https
        components.host = LocalAPI.host          // dapi.kakao.com
        components.path = LocalAPI.path          // /v2/local/search/category.json
        
        // 쿼리 파라미터 배열 구성
        components.queryItems = [
            // 카테고리 그룹 코드: CS2 = 편의점
            URLQueryItem(name: "category_group_code", value: "CS2"),
            
            // 검색 기준 경도 (longitude)
            URLQueryItem(name: "x", value: "\(mapPoint.mapPointGeo().longitude)"),
            
            // 검색 기준 위도 (latitude)
            URLQueryItem(name: "y", value: "\(mapPoint.mapPointGeo().latitude)"),
            
            // 검색 반경: 500미터
            URLQueryItem(name: "radius", value: "500"),
            
            // 정렬 기준: 거리순
            URLQueryItem(name: "sort", value: "distance")
        ]
        
        return components
    }
}
