//
//  Repository.swift
//  GitHubRepository
//
//  Created by 이상훈 on 8/9/25.
//

struct Repository: Decodable {
    let id: Int
    let name: String
    let description: String?      // null 허용
    let stargazersCount: Int
    let language: String?         // null 허용

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case stargazersCount = "stargazers_count"
        case language
    }
}
