//
//  Group.swift
//  VkApp
//
//  Created by Карим Руабхи on 24.12.2021.
//

import Foundation

class Group {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    init() {
        self.name = ""
    }
    
    deinit {
        print("Item of Group have deinitialized")
    }
}
