//
//  RealmPhotoCells.swift
//  VkApp
//
//  Created by Карим Руабхи on 27.02.2022.
//

import Foundation
import RealmSwift

class RealmPhotoCell: Object {
    @Persisted(primaryKey: true) var url: String = ""
    @Persisted var height: Int = 0
    @Persisted var type: String = ""
}

extension RealmPhotoCell {
    convenience init (photo: Photo) {
        self.init()
        self.url = photo.url
        self.type = photo.type
        self.height = photo.height
    }
}
