//
//  ErrorModel.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/4/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import Foundation

struct ErrorModel: Error {
    var message:String
    
    init() {
        self.message = "Unknown error"
    }
    
    init(message:String) {
        self.message = message
    }
    
    var errorDescription: String? {
        return self.message
    }
}

extension ErrorModel: LocalizedError {
    var localizedDescription: String {
        return self.message
    }
}
