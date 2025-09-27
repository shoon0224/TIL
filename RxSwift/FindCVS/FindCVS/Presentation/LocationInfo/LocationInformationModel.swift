

import Foundation
import RxSwift

// MARK: - LocationInformationModel
/**
 * 위치 정보 관련 비즈니스 로직을 담당하는 Model 클래스
 * 
 * 역할:
 * - MVVM 패턴에서 Model 계층 담당
 * - 네트워크 통신과 데이터 변환 로직 처리
 * - View와 독립적인 순수한 비즈니스 로직 제공
 * - 테스트 가능한 단위로 로직 분리
 */
struct LocationInformationModel {
    // 네트워크 통신을 담당하는 LocalNetwork 인스턴스
    let localNetwork: LocalNetwork
    
    // MARK: - Initializer
    /**
     * LocationInformationModel 초기화
     * 
     * @param localNetwork: 의존성 주입을 통한 네트워크 계층 (기본값: LocalNetwork())
     * 
     * 역할:
     * - 의존성 주입을 통한 테스트 가능성 확보
     * - 네트워크 계층과의 결합도 낮춤
     */
    init(localNetwork: LocalNetwork = LocalNetwork()) {
        self.localNetwork = localNetwork
    }
    
    // MARK: - getLocation
    /**
     * 주어진 좌표를 기준으로 주변 편의점 정보를 가져오는 메서드
     * 
     * @param mapPoint: 검색 기준 좌표
     * @return Single<Result<LocationData, URLError>>: RxSwift Single로 래핑된 결과
     * 
     * 역할:
     * - 네트워크 계층에 요청을 위임
     * - Model 계층에서 네트워크 요청의 진입점 역할
     */
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return localNetwork.getLocation(by: mapPoint)
    }
    
    // MARK: - documentsToCellData
    /**
     * KLDocument 배열을 DetailListCellData 배열로 변환하는 메서드
     * 
     * @param data: 카카오 API 응답 문서 배열
     * @return [DetailListCellData]: UI 표시용 데이터 배열
     * 
     * 역할:
     * - API 응답 모델을 UI 표시용 모델로 변환
     * - 주소 우선순위 로직 적용 (도로명 주소 > 지번 주소)
     * - 좌표를 MTMapPoint로 변환
     * - 함수형 프로그래밍의 map 연산자 활용
     */
    func documentsToCellData(_ data: [KLDocument]) -> [DetailListCellData] {
        return data.map {
            // 도로명 주소가 있으면 도로명 주소를, 없으면 지번 주소를 사용
            let address = $0.roadAddressName.isEmpty ? $0.addressName : $0.roadAddressName
            
            // 문자열 좌표를 MTMapPoint로 변환
            let point = documentToMTMapPoint($0)
            
            // DetailListCellData 객체 생성하여 반환
            return DetailListCellData(
                placeName: $0.placeName,
                address: address,
                distance: $0.distance,
                point: point
            )
        }
    }
    
    // MARK: - documentToMTMapPoint
    /**
     * KLDocument의 문자열 좌표를 MTMapPoint로 변환하는 메서드
     * 
     * @param doc: 변환할 KLDocument 객체
     * @return MTMapPoint: DaumMap에서 사용할 지도 좌표 객체
     * 
     * 역할:
     * - 문자열 좌표를 Double로 변환 (실패 시 0.0 사용)
     * - MTMapPoint 객체 생성으로 지도에 표시 가능한 형태로 변환
     * - 안전한 타입 변환 (옵셔널 바인딩과 nil coalescing 활용)
     */
    func documentToMTMapPoint(_ doc: KLDocument) -> MTMapPoint {
        // 문자열 경도를 Double로 변환 (실패 시 0.0)
        let longitude = Double(doc.x) ?? .zero
        
        // 문자열 위도를 Double로 변환 (실패 시 0.0)
        let latitude = Double(doc.y) ?? .zero
        
        // MTMapPoint 객체 생성하여 반환
        return MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
    }
}
