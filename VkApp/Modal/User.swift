//
//  User.swift
//  VkApp
//
//  Created by Карим Руабхи on 24.12.2021.
//

import Foundation


class User {
    
    var firstname: String
    var lastname: String
    var fullname: String
    var age: UInt? = nil
    var photos: [String]? = nil
    
    init(name: String, surname: String, age: UInt, photosArr: [String]) {
        self.firstname = name
        self.lastname = surname
        self.age = age
        self.photos = photosArr
        self.fullname = "\(lastname) \(firstname)"
    }
    
    init() {
        self.firstname = ""
        self.lastname = ""
        self.fullname = "\(lastname) \(firstname)"
    }
    
    deinit {
        print("Item of User have deinitialized")
    }
}
