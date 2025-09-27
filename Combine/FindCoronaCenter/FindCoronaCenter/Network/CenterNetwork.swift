//
//  CenterNetwork.swift
//  FindCoronaCenter
//
//  Created by 이상훈 on 9/26/25.
//

import Foundation
import Combine

class CenterNetwork {
    private let session: URLSession
    let api = CenterAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getCenterList() -> AnyPublisher<[Center], URLError> {
        guard let url = api.getCenterListComponents().url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Infuser 3gUbMESKsPcNX1hxbGHzWQPY2uhJ6+d4Y/bPogATMZEwV7OJNfzXbYivSt02upze4G4/VYKFGKY25xgKl6my3g==", forHTTPHeaderField: "Authorization")
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.unknown)
                }
                
                switch httpResponse.statusCode {
                case 200..<300:
                    return data
                case 400..<500:
                    throw URLError(.clientCertificateRejected)
                default:
                    throw URLError(.unknown)
                }
            }
            .decode(type: CenterAPIResponse.self, decoder: JSONDecoder()) //Response를 가져오지만
            .map { $0.data } //그중 데이터만 뽑아달란 뜻
            .mapError{ $0 as! URLError }
            .eraseToAnyPublisher()
    }
}
