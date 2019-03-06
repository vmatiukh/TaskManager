//
//  UserModel.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/4/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import Foundation

struct UserModel:Encodable {
    private let email:String
    private let password:String
    
    init(email:String, password:String) {
        self.email = email
        self.password = password
    }
}
