//
//  AppController.swift
//  UserManager
//
//  Created by Jubin Jose on 2018-02-22.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit

//TODO: This class is not required. Needs to be removed

class AppController: NSObject {
    static var shared = AppController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    fileprivate override init() {
        
    }
}
