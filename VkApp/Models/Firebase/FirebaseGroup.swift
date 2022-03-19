//
//  FirebaseFriends.swift
//  VkApp
//
//  Created by Карим Руабхи on 19.03.2022.
//

import Foundation
import Firebase

final class FirebaseGroup {
    let name: String
    let photo: String
    let id: Int
    let reference: DatabaseReference?
    
    init (id: Int, name: String, photo: String) {
        self.id = id
        self.name = name
        self.photo = photo
        self.reference = nil
    }
    
    init? (snapshot: DataSnapshot) {
        print(snapshot.value as? [String: Any])
        guard
            let value = snapshot.value as? [String: Any],
            let id = Int(snapshot.key as? String ?? "1"),
            let name = value["name"] as? String,
            let photo = value["photo"] as? String
        else { return nil }
        
        self.reference = snapshot.ref
        self.name = name
        self.photo = photo
        self.id = id
    }
    
}
