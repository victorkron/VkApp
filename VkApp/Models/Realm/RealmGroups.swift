//
//  RealmGroups.swift
//  VkApp
//
//  Created by Карим Руабхи on 27.02.2022.
//

import Foundation
import RealmSwift

class RealmGroup: Object {
    @Persisted(primaryKey: true) var id: Int = 0
//    @Persisted(indexed: true) var value: String = ""
    @Persisted var name: String = ""
    @Persisted var photo: String = ""
}

extension RealmGroup {
    convenience init(group: GroupData) {
        self.init()
        self.id = group.id
        self.name = group.name
        self.photo = group.photo
    }
}


