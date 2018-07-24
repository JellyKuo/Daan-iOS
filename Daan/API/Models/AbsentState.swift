//
//  AbsentState.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/14.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation

struct AbsentState: Codable {
    let date: String
    let type: String
    let cls: String  //class
    
    enum CodingKeys:String,CodingKey{
        case date
        case type
        case cls = "class"
    }
}
