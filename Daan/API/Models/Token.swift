//
//  Token.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import ObjectMapper

struct Token: Mappable,Codable {
    var token: String
    
    init?(map: Map) {
        self.token = ""
    }
    
    mutating func mapping(map: Map) {
        token   <- map["token"]
    }
}
