//
//  CenterAPIResponse.swift
//  FindCoronaCenter
//
//  Created by 이상훈 on 9/25/25.
//

import Foundation

struct CenterAPIResponse: Decodable {
    let data: [Center]
}
