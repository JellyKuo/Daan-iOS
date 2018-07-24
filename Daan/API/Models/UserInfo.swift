//
//  UserInfo.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let name: String
    let nick: String
    let cls: String  //class
    let group: String
    
    enum CodingKeys:String,CodingKey{
        case name
        case nick
        case cls = "class"
        case group
    }
}
