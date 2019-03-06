//
//  AuthManager.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/4/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import Foundation
import Alamofire

typealias SuccessBlock = ()->()
typealias BoolSuccessBlock = (Bool)->()
typealias ErrorBlock = (Error)->()

class AuthManager: NetworkManager {
    
    static var isLogined: Bool {
        return TokenManager.loadToken != nil
    }
    
    func login(params:Parameters, successBlock:@escaping SuccessBlock, errorBlock:@escaping ErrorBlock) {
        Alamofire.request(Endpoint.auth.requestUrl, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { result in
            switch result.result {
            case .success(let json):
                if let json = json as? [String:Any], let token = json["token"] as? String {
                    TokenManager.save(token: token)
                    successBlock()
                } else {
                    errorBlock(ErrorModel())
                }
                break
            case .failure(let error ):
                errorBlock(self.handle(error: error, data:result.data))
                break
            }
        }
    }
    
    func register(params:[String:Any], successBlock:@escaping SuccessBlock, errorBlock:@escaping ErrorBlock) {
        Alamofire.request(Endpoint.users.requestUrl, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { result in
            switch result.result {
            case .success(let json):
                if let json = json as? [String:Any], let token = json["token"] as? String {
                    TokenManager.save(token: token)
                    successBlock()
                } else {
                    errorBlock(ErrorModel())
                }
                break
            case .failure(let error ):
                errorBlock(self.handle(error: error, data:result.data))
                break
            }
        }
    }
}
