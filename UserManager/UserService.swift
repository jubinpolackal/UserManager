//
//  UserService.swift
//  UserManager
//
//  Created by Jubin Jose on 2018-02-22.
//  Copyright © 2018 Jubin Jose. All rights reserved.
//

import UIKit

class UserService: NSObject {
    let dataURL = "https://jsonplaceholder.typicode.com/users"
    var urlSession : URLSession?
    var dataTask: URLSessionDataTask?
    
    override init() {
        urlSession = URLSession(configuration: .default)
    }

    func getUsers(completion: @escaping (Data?, Error?)->Void){
        let url = URL(string: self.dataURL)
        dataTask = self.urlSession?.dataTask(with: url!){
            data, response, error in
            
            if let error = error{
                print(error.localizedDescription)
            }else if let data = data{
                completion(data, error)
            }
        }
        dataTask?.resume()
    }
}
