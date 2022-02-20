//
//  UserData+CoreDataProperties.swift
//  
//
//  Created by Карим Руабхи on 19.02.2022.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var id: UUID?

}
