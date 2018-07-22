//
//  HistoryGrade.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/17.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import ObjectMapper

struct HistoryScore: Codable,Mappable {
    var subject: String?
    var type: String?
    var credit: String?
    var score: Int?
    var qualify: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        subject  <- map["subject"]
        type     <- map["type"]
        credit   <- map["credit"]
        score    <- map["score"]
        qualify  <- map["qualify"]
    }
}
