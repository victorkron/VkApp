//
//  Group.swift
//  VkApp
//
//  Created by Карим Руабхи on 24.12.2021.
//

import Foundation

class Group {
    var id: Int = 0
    var name: String
    var photo: String? = nil
    
    init(name: String, photo: String, id: Int) {
        self.name = name
        self.photo = photo
        self.id = id
    }
    
    init() {
        self.name = ""
        self.photo = ""
    }
    
    deinit {
        print("Item of Group have deinitialized")
    }
}
