//
//  CoreDataManager.swift
//  UserManager
//
//  Created by Jubin Jose on 2018-02-22.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    static var shared = CoreDataManager()

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "UserManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Public methods
    
    func getUser(id: String) -> User?{
        var user:User?
        
        let fetchRequst = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequst.predicate = predicate
        
        do{
             let res = try self.persistentContainer.viewContext.fetch(fetchRequst)
            if res.count > 0 {
                user = res[0] as? User
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        return user
    }
    
    func getUserEntity() -> User{
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: self.persistentContainer.viewContext)
        let userObj = User(entity: userEntity!, insertInto: self.persistentContainer.viewContext)
        
        return userObj
    }
    
    func getAddressEntity() -> Address{
        let addressEntity = NSEntityDescription.entity(forEntityName: "Address", in: self.persistentContainer.viewContext)
        let addressObject = Address(entity: addressEntity!, insertInto: self.persistentContainer.viewContext)
        
        return addressObject
    }
    
    func getLocationEntity() -> GeoLocation {
        let locEntity = NSEntityDescription.entity(forEntityName: "GeoLocation", in: self.persistentContainer.viewContext)
        let locObject = GeoLocation(entity: locEntity!, insertInto: self.persistentContainer.viewContext)
        
        return locObject
    }
}
