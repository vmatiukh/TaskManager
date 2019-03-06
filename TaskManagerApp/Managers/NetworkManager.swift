//
//  NetworkManager.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/5/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private static let baseURL = "http://testapi.doitserver.in.ua/api"
    
    enum Endpoint:String {
        case tasks, users, auth
        var requestUrl:String { return baseURL + "/" + self.rawValue }
    }
    
    internal func handle(error:Error, data:Data?) -> ErrorModel {
        if let responseData = data, let parsedResponseData = try! JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any], let errorMessage = parsedResponseData["message"] as? String {
            return ErrorModel(message: errorMessage)
        }
        return ErrorModel(message: error.localizedDescription)
    }
}
