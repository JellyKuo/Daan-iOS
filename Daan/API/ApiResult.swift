//
//  ApiResult.swift
//  Daan
//
//  Created by 郭東岳 on 2018/5/30.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import Foundation

class ApiResult<T:Codable> {
    var success:Bool
    var apiError:ApiError?
    var netError:Error?
    var result:T?
    
    init(_ success:Bool,_ result:T) {
        self.success = success
        self.apiError = nil
        self.netError = nil
        self.result = result
    }
    
    init(_ success:Bool, apiError:ApiError? = nil) {
        self.success = success
        self.apiError = apiError
        self.netError = nil
        self.result = nil
    }
    
    init(_ success:Bool, netError:Error? = nil) {
        self.success = success
        self.apiError = nil
        self.netError = nil
        self.result = nil
    }
}
