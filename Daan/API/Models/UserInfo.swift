//
//  UserInfo.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserInfo: Mappable {
    var name: String?
    var nick: String?
    var cls: String?  //class
    var group: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name   <- map["name"]
        nick   <- map["nick"]
        cls    <- map["class"]
        group  <- map["group"]
    }
}
