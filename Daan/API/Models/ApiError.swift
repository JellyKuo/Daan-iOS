//
//  Error.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import ObjectMapper

struct ApiError: Codable,Mappable {
    var code: Int
    var error: String
    
    // Just for the new Api can initialize this
    init() {
        code = 0
        error = ""
    }
    
    init?(map: Map) {
        self.code = 0
        self.error = ""
    }
    
    mutating func mapping(map: Map) {
        code   <- map["code"]
        error  <- map["error"]
    }
}
