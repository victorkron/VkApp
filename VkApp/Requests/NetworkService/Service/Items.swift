//
//  Items.swift
//  VkApp
//
//  Created by Карим Руабхи on 31.03.2022.
//

import Foundation

struct Items<ItemsType: Decodable>: Decodable {
    let items: [ItemsType]
    let count: Int?
}
