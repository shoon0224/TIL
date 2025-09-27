

import RxSwift

// MARK: - LocalNetwork
/**
 * 카카오 로컬 API와의 네트워크 통신을 담당하는 클래스
 * 
 * 역할:
 * - 실제 HTTP 요청을 수행하고 응답을 처리
 * - RxSwift를 사용한 비동기 네트워크 통신 구현
 * - API 응답 데이터를 Swift 객체로 파싱
 * - 에러 처리 및 Result 타입으로 성공/실패 캡슐화
 * - MVVM 패턴에서 Model 계층의 네트워크 서비스 역할
 */
class LocalNetwork {
    // URLSession 인스턴스 (의존성 주입을 통한 테스트 가능성 확보)
    private let session: URLSession
    
    // API URL 구성을 위한 LocalAPI 인스턴스
    let api = LocalAPI()
    
    // MARK: - Initializer
    /**
     * LocalNetwork 초기화
     * 
     * @param session: 네트워크 요청에 사용할 URLSession (기본값: .shared)
     * 
     * 역할:
     * - 의존성 주입을 통해 URLSession을 외부에서 주입 받음
     * - 테스트 시 MockURLSession 주입 가능
     */
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - getLocation
    /**
     * 주어진 좌표 기준으로 주변 편의점 정보를 가져오는 메서드
     * 
     * @param mapPoint: 검색 기준 좌표
     * @return Single<Result<LocationData, URLError>>: RxSwift Single로 래핑된 결과
     * 
     * RxSwift 핵심 개념:
     * - Single: 정확히 하나의 값 또는 에러를 방출하는 Observable
     * - Result: Swift의 성공/실패를 타입 세이프하게 표현하는 열거형
     * - map: 데이터 변환 연산자
     * - catch: 에러 처리 연산자
     * - asSingle: Observable을 Single로 변환
     */
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        // 1. URL 유효성 검사
        guard let url = api.getLocation(by: mapPoint).url else {
            // URL이 잘못된 경우 즉시 실패 결과 반환
            return .just(.failure(URLError(.badURL)))
        }
        
        // 2. HTTP 요청 구성
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        // 카카오 API 인증 헤더 추가 (REST API 키 사용)
        request.setValue("KakaoAK ***", forHTTPHeaderField: "Authorization")
        
        // 3. RxSwift를 사용한 비동기 네트워크 요청
        return session.rx.data(request: request as URLRequest)
            .map { data in
                // 4. JSON 데이터를 Swift 객체로 파싱
                do {
                    // JSONDecoder를 사용하여 LocationData 객체로 디코딩
                    let locationData = try JSONDecoder().decode(LocationData.self, from: data)
                    return .success(locationData)  // 성공 시 .success로 래핑
                } catch {
                    // JSON 파싱 실패 시 .failure로 래핑
                    return .failure(URLError(.cannotParseResponse))
                }
            }
            // 5. 네트워크 에러 처리
            .catch { _ in 
                // 모든 네트워크 에러를 .cannotLoadFromNetwork로 통일
                .just(Result.failure(URLError(.cannotLoadFromNetwork))) 
            }
            // 6. Observable을 Single로 변환
            .asSingle()
    }
}
