//
//  User+CoreDataProperties.swift
//  UserManager
//
//  Created by Jubin Jose on 2018-02-22.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var userName: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    //TODO: Rename relationship to something meaningful
    @NSManaged public var relationship: Address?
    
    //Create object from dictionary
    public func createFromDictionary(json:[String:Any?]){
        self.name = json["name"] as? String
        self.id = (json["id"] as? Int64)!
        self.userName = json["username"] as? String
        self.email = json["email"] as? String
        self.phone = json["phone"] as? String
    }

}
