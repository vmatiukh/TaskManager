//
//  TaskManager.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/5/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import Foundation
import Alamofire

typealias DictSuccessBlock = ([String:Any])->()
typealias DictArraySuccessBlock = ([[String:Any]])->()

class TaskManager: NetworkManager {
    lazy var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        if let token = TokenManager.loadToken {
            configuration.httpAdditionalHeaders = ["Authorization": "Bearer " + token]
        }
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    func loadTasks(page:Int, sorting:String, successBlock:@escaping DictArraySuccessBlock, errorBlock:@escaping ErrorBlock) {
        self.sessionManager.request(Endpoint.tasks.requestUrl, method: .get, parameters: ["page": page, "sort":sorting], encoding: URLEncoding.default).validate().responseJSON { result in
            switch result.result {
            case .success(let json):
                if let json = json as? [String:Any], let tasks = json["tasks"] as? [[String: Any]] {
                    successBlock(tasks)
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
    
    func saveTask(params:[String:Any], successBlock:@escaping DictSuccessBlock, errorBlock:@escaping ErrorBlock){
        self.sessionManager.request(Endpoint.tasks.requestUrl, method: .post, parameters: params, encoding: URLEncoding.default).validate().responseJSON { result in
            switch result.result {
            case .success(let json):
                if let json = json as? [String:Any], let tasks = json["task"] as? [String: Any] {
                    successBlock(tasks)
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

    func editTask(id:String, params:[String:Any], successBlock:@escaping SuccessBlock, errorBlock:@escaping ErrorBlock){
        self.sessionManager.request(Endpoint.tasks.requestUrl + "/\(id)", method: .put, parameters: params, encoding: URLEncoding.default).validate().responseJSON { result in
            switch result.result {
            case .success(_):
                successBlock()
                break
            case .failure(let error ):
                errorBlock(self.handle(error: error, data:result.data))
                break
            }
        }
    }
    
    func removeTask(id:String, successBlock:@escaping SuccessBlock, errorBlock:@escaping ErrorBlock){
        self.sessionManager.request(Endpoint.tasks.requestUrl + "/\(id)", method: .delete, parameters: nil, encoding: URLEncoding.default).validate().responseJSON { result in
            switch result.result {
            case .success(_):
                successBlock()
                break
            case .failure(let error ):
                errorBlock(self.handle(error: error, data:result.data))
                break
            }
        }
    }
}
