//
//  SectionalScore.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/15.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import ObjectMapper

struct SectionalScore: Mappable {
    var subject: String?
    var first_section: Int?
    var second_section: Int?
    var last_section: Int?
    var performance: Int?
    var average: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        subject         <- map["subject"]
        first_section   <- map["first_section"]
        second_section  <- map["second_section"]
        last_section    <- map["last_section"]
        performance     <- map["performance"]
        average         <- map["average"]
    }
}
