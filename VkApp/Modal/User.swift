//
//  User.swift
//  VkApp
//
//  Created by Карим Руабхи on 24.12.2021.
//

import Foundation


class User {
    
    var name: String
    var age: UInt
    
    init(name: String, age: UInt) {
        self.name = name
        self.age = age
    }
    
    deinit {
        print("Item of User have deinitialized")
    }
}
