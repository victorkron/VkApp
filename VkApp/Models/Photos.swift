//
//  Photos.swift
//  VkApp
//
//  Created by Карим Руабхи on 17.02.2022.
//

import Foundation

struct PhotosResponse {
    let response: Photos
}

extension PhotosResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct Photos {
    let count: Int
    let items: [Albums]
    
}

extension Photos: Codable {
    enum CodingKeys: String, CodingKey {
        case count
        case items
    }
}

struct Albums {
    let sizes: [Photo]
//    let likes: Likes
    let ownerID: Int

}

extension Albums: Codable {
    enum CodingKeys: String, CodingKey {
        case sizes
//        case likes
        case ownerID = "owner_id"
    }
}

struct Photo {
    let height: Int
    let url: String
    let type: String
}

extension Photo: Codable {
    enum CodingKeys: String, CodingKey {
        case height
        case url
        case type
    }
}



