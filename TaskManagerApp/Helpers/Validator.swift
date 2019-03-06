//
//  Validator.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/4/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import Foundation

class Validator {
    static func validate(email: String?) throws -> String {
        guard let email = email, email.count > 0 else {
            throw ErrorModel(message:"Empty e-mail. Please enter email")
        }
        let emailRegex = try NSRegularExpression(pattern: "\\w+@[a-zA-Z_]+?\\.[a-zA-Z]{2,3}")
        if emailRegex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) == nil {
            throw ErrorModel(message: "Invalid email. Please try again")
        }
        return email
    }
    
    static func validate(password: String?) throws -> String {
        guard let password = password, password.count > 0 else {
            throw ErrorModel(message:"Empty password. Please enter password")
        }
        let passwordRegex = try NSRegularExpression(pattern: "(\\w|\\d){6,}")
        if passwordRegex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) == nil {
            throw ErrorModel(message: "Invalid password. Password must be at least 6 symbols. Please try again")
        }
        return password
    }
}
