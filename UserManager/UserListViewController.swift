//
//  UserListViewController.swift
//  UserManager
//
//  Created by Jubin Jose on 2018-02-22.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit
import CoreData

class UserListViewController: UITableViewController {
    
    var users = [User]()
    let userRequest = NSFetchRequest<User>(entityName: "User")
    var userResultsController:NSFetchedResultsController<NSFetchRequestResult>?
    var selectedUser:User?

    //MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        self.userRequest.sortDescriptors = [sortDescriptor]
        self.userResultsController  = NSFetchedResultsController(fetchRequest: userRequest,
                                                                 managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil,
                                                                 cacheName: nil) as? NSFetchedResultsController<NSFetchRequestResult>
        self.downloadUsers()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "userDetailSegue" {
            let destinationVC = segue.destination as? UserDetailViewController
            if let destinationVC = destinationVC {
                destinationVC.setUserData(user: self.selectedUser)
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.userResultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionInfo = self.userResultsController?.sections![section]{
            print("Number of rows: \(sectionInfo.numberOfObjects)")
            return sectionInfo.numberOfObjects
        }
        else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "userCellId", for)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCellId", for: indexPath)
        
        self.configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    //MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedUser = self.userResultsController?.object(at: indexPath) as? User
        self.performSegue(withIdentifier: "userDetailSegue", sender: self)
    }
    
    //MARK: - Private methods
    
    fileprivate func configureCell(cell:UITableViewCell, indexPath:IndexPath){
        let userObject = self.userResultsController?.object(at: indexPath) as? User
        if let user = userObject{
            cell.textLabel?.text = user.name
        }
    }
    
    //Download users
    fileprivate func downloadUsers(){
        let dataDownloader = UserService()
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        dataDownloader.getUsers(){
            [weak self] data, error in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            //TODO: This should be moved to User service class
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    
                    for user in json!{
                        let theId = user["id"] as? Int64
                        if let theId = theId{
                            let userId = "\(theId)"
                            print(userId)
                            //Check if user already exists
                            let existingUser = CoreDataManager.shared.getUser(id: userId)
                            if existingUser == nil {
                                let userObj = CoreDataManager.shared.getUserEntity()
                                
                                //Form user object
                                userObj.createFromDictionary(json: user)
                                
                                //Form address object
                                let addressObject = CoreDataManager.shared.getAddressEntity()
                                let addressDict = (user["address"] as? [String: Any?])!
                                addressObject.createFromDictionary(json: (user["address"] as? [String: Any?])!)
                                
                                //Form location object
                                let locObject = CoreDataManager.shared.getLocationEntity()
                                locObject.createFromDictionary(json: (addressDict["geo"] as! [String : Any?]))
                                
                                //Set entity relationships
                                addressObject.relationship = locObject
                                userObj.relationship = addressObject
                                
                                //Save entity
                                try managedContext.save()
                            }
                        }
                    }
                }
                catch{
                    self?.showErrorAlert(title: "Error", message: error.localizedDescription)
                    print(error.localizedDescription)
                }
            }else if let error = error{
                self?.showErrorAlert(title: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
            }
            self?.performUserFetch()
        }
    }
    
    // Load the fetched results controller with data and reload teh tableview
    fileprivate func performUserFetch(){
        do{
            try self.userResultsController?.performFetch()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            fatalError("Failed to fetch eintities")
        }
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
    }
    //Common Error alert
    fileprivate func showErrorAlert(title: String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
