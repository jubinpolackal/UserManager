//
//  UserDetailViewController.swift
//  UserManager
//
//  Created by Jubin Jose on 2018-02-22.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UserDetailViewController: UIViewController {

    var user:User?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    //MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.populateUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - public methods

    func setUserData(user: User?) {
        if let user = user{
            self.user = user
        }
    }
    
    //MARK: -Private methods
    
    fileprivate func setupView(){
        self.profileImageView.layer.cornerRadius = 10.0
        self.profileImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.profileImageView.layer.borderWidth = 1.0
    }
    
    fileprivate func populateUserData() {
        self.title = self.user?.name
        self.emailLabel.text = user?.email
        self.phoneLabel.text = user?.phone
        let address: Address = (self.user?.relationship)!
        self.addressLabel.text = "\(address.suite!) - \(address.street!)\nZip: \(address.zip!)"
        
        let annotation = MKPointAnnotation()
        let loc = address.relationship
        let lat = (loc?.lat! as! NSString).doubleValue
        let long = (loc?.long! as! NSString).doubleValue
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(annotation)
    }
}
