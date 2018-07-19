//
//  Register.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import ObjectMapper

struct Register: Codable,Mappable {
    var email: String
    var password: String
    var user_group:String
    var school_account:String
    var school_pwd:String
    var nick:String
    
    init?(map: Map) {
        self.email = ""
        self.password = ""
        self.user_group = ""
        self.school_account = ""
        self.school_pwd = ""
        self.nick = ""
    }
    
     mutating func mapping(map: Map) {
        email           <- map["email"]
        password        <- map["password"]
        user_group      <- map["user_group"]
        school_account  <- map["school_account"]
        school_pwd      <- map["school_pwd"]
        nick            <- map["nick"]
    }
}
