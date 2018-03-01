//
//  GeoLocation+CoreDataProperties.swift
//  UserManager
//
//  Created by Jubin Jose on 2018-02-22.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//
//

import Foundation
import CoreData


extension GeoLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeoLocation> {
        return NSFetchRequest<GeoLocation>(entityName: "GeoLocation")
    }

    @NSManaged public var lat: String?
    @NSManaged public var long: String?
    
    //Create object from dictionary
    public func createFromDictionary(json:[String:Any?]){
        self.lat = json["lat"] as? String
        self.long = json["lng"] as? String
    }

}
