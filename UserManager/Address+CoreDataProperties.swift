//
//  Address+CoreDataProperties.swift
//  UserManager
//
//  Created by Jubin Jose on 2018-02-22.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var city: String?
    @NSManaged public var suite: String?
    @NSManaged public var street: String?
    @NSManaged public var zip: String?
    //TODO: Rename relationship to something meaningful
    @NSManaged public var relationship: GeoLocation?
    
    //Create object from dictionary
    public func createFromDictionary(json:[String:Any?]){
        self.city = json["city"] as? String
        self.suite = json["suite"] as? String
        self.street = json["street"] as? String
        self.zip = json["zipcode"] as? String
    }

}
