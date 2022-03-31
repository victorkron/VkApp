//
//  Response.swift
//  VkApp
//
//  Created by Карим Руабхи on 31.03.2022.
//

import Foundation

struct Response<ItemsType: Decodable>: Decodable {
    let response: Items<ItemsType>
}
