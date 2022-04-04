//
//  RealmFriends.swift
//  VkApp
//
//  Created by Карим Руабхи on 27.02.2022.
//

import Foundation
import RealmSwift

class RealmFriend: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var photo: String = ""
    @Persisted var photo100: String = ""
    @Persisted var photo200: String = ""
}

extension RealmFriend {
    convenience init(user: User) {
        self.init()
        self.id = user.id
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.photo = user.photo
        self.photo100 = user.photo100
        self.photo200 = user.photo200
    }
}

