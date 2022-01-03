//
//  User.swift
//  VkApp
//
//  Created by Карим Руабхи on 24.12.2021.
//

import Foundation


class User {
    
    var name: String
    var age: UInt? = nil
    var photos: [String]? = nil
    
    init(name: String, age: UInt, photosArr: [String]) {
        self.name = name
        self.age = age
        self.photos = photosArr
    }
    
    init() {
        self.name = ""
    }
    
    deinit {
        print("Item of User have deinitialized")
    }
}
