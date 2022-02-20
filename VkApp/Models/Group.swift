//
//  Group.swift
//  VkApp
//
//  Created by Карим Руабхи on 24.12.2021.
//

import Foundation

class Group {
    
    var name: String
    var photo: String? = nil
//    var id: Int = 0
    
    init(name: String, photo: String) {
        self.name = name
        self.photo = photo
//        self.id = id
    }
    
    init() {
        self.name = ""
        self.photo = ""
    }
    
    deinit {
        print("Item of Group have deinitialized")
    }
}
