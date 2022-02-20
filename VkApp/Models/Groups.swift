//
//  Groups.swift
//  VkApp
//
//  Created by Карим Руабхи on 16.02.2022.
//

import Foundation


struct GroupsResponse {
    let response: Groups
}

extension GroupsResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct Groups {
    let count: Int
    let items: [GroupData]
}

extension Groups: Codable {
    enum CodingKeys: String, CodingKey {
        case count
        case items
    }
}

struct GroupData {
    let id: Int
    let name: String
    let photo: String
}

extension GroupData: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo = "photo_50"
    }
}
