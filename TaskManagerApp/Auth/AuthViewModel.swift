//
//  AuthViewModel.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/4/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import Foundation

class AuthViewModel {
    private var userModel:UserModel!
    private let authManager = AuthManager()
    
    func authUser(email:String?, password:String?, isRegister:Bool, successBlock:@escaping SuccessBlock, errorBlock:@escaping ErrorBlock) throws {
        do {
           let email = try Validator.validate(email: email)
           let password = try Validator.validate(password: password)
            
            userModel = UserModel(email: email, password: password)
            if isRegister {
                try regiter(successBlock: successBlock, errorBlock: errorBlock)
            } else {
                try login(successBlock: successBlock, errorBlock: errorBlock)
            }
        } catch {
           errorBlock(error)
        }
    }
    
    private func login(successBlock:@escaping SuccessBlock, errorBlock:@escaping ErrorBlock) throws {
        let paramsData = try JSONEncoder().encode(userModel)
        guard let params = try JSONSerialization.jsonObject(with: paramsData, options: .allowFragments) as? [String:Any] else {
            throw ErrorModel()
        }
        authManager.login(params:params, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    private func regiter(successBlock:@escaping SuccessBlock, errorBlock:@escaping ErrorBlock) throws {
        let paramsData = try JSONEncoder().encode(userModel)
        guard let params = try JSONSerialization.jsonObject(with: paramsData, options: .allowFragments) as? [String:Any] else {
            throw ErrorModel()
        }
        authManager.register(params: params, successBlock: successBlock, errorBlock: errorBlock)
    }
    
}
