//
//  RealmNews.swift
//  VkApp
//
//  Created by Карим Руабхи on 31.03.2022.
//

import Foundation
import RealmSwift

class RealmNews: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var groupName: String = ""
    @Persisted var date: String = ""
    @Persisted var avatar: String = ""
    @Persisted var photo: String?
    @Persisted var text: String?
    @Persisted var likes: String?
    @Persisted var comments: String?
    @Persisted var forwarded: String?
    @Persisted var views: String?
}

extension RealmNews {
    convenience init(news: News) {
        self.init()
    }
}
