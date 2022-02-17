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
    
    
//    init(id: Int, name: String, surname: String, photo: String) {
//        self.id = id
//        self.firstName = name
//        self.lastName = surname
//        self.photo = photo
//    }
//
//    deinit {
//        print("Item of User have deinitialized")
//    }
}

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_100"
    }
}
