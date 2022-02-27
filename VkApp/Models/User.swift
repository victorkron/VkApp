//
//  User.swift
//  VkApp
//
//  Created by Карим Руабхи on 24.12.2021.
//

import Foundation


struct FriendsResponse {
    let response: Friends
}

extension FriendsResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct Friends {
    let count: Int
    let items: [User]
}

extension Friends: Codable {
    enum CodingKeys: String, CodingKey {
        case count
        case items
    }
}

struct User {
    let id: Int
    let firstName: String
    let lastName: String
    let photo: String
    let photo100: String
    let photo200: String
}

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}
