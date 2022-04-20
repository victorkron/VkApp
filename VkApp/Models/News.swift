//
//  News.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import Foundation
import UIKit

struct NewsResponse {
    let response: NewsData
}

extension NewsResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct NewsData {
    var items: [News]
    var nextFrom: String
}

extension NewsData: Codable {
    enum CodingKeys: String, CodingKey {
        case items = "items"
        case nextFrom = "next_from"
    }
}

struct News {
    let sourceID: Int
    var text: String?
    let date: Date
    let contentImages: [Attachment]?
    let likes: Likes
    let reposts: Reposts
    let comments: Comments
    
    var aspectRatio: CGFloat {
        get {
            let aspectRatio = contentImages?.compactMap{ $0.photo?.sizes.last?.aspectRatio }.last
            return aspectRatio ?? 1
        }
    }
}

extension News: Comparable {
    static func < (lhs: News, rhs: News) -> Bool {
        lhs.date < rhs.date
    }
    
    static func == (lhs: News, rhs: News) -> Bool {
        lhs.date == rhs.date && lhs.sourceID == rhs.sourceID
    }
}

extension News: Codable {
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


struct Attachment: Codable {
    let type: String
    let photo: Albums?
}
