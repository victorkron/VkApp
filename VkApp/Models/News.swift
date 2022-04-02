//
//  News.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import Foundation
import UIKit

struct News {
    let sourceID: Int
    var text: String?
    let date: Date
    let contentImages: [Attachment]?
    let likes: Likes
    let reposts: Reposts
    let comments: Comments
}

extension News: Comparable {
    static func < (lhs: News, rhs: News) -> Bool {
        lhs.date < rhs.date
    }
    
    static func == (lhs: News, rhs: News) -> Bool {
        lhs.date == rhs.date && lhs.sourceID == rhs.sourceID
    }
}

extension News: Decodable {
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case text
        case contentImages = "attachments"
        case comments
        case likes
        case reposts
    }
}

struct Likes: Codable {
    let count: Int
    enum CodingKeys: String, CodingKey {
        case count
    }
}

struct Reposts: Codable {
    let count: Int
    enum CodingKeys: String, CodingKey {
        case count
    }
}

struct Comments: Codable {
    let count: Int
    enum CodingKeys: String, CodingKey {
        case count
    }
}


struct Attachment: Decodable {
    let type: String
    let photo: Albums?
}
