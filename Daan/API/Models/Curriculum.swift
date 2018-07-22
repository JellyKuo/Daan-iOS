//
//  Curriculum.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/18.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import ObjectMapper

struct Curriculum: Codable,Mappable {
    var start: String?
    var end: String?
    var subject: String?
    var teacher: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        start    <- map["start"]
        end      <- map["end"]
        subject  <- map["subject"]
        teacher  <- map["teacher"]
    }
}

struct CurriculumWeek: Codable,Mappable {
    var week1: [Curriculum]?
    var week2: [Curriculum]?
    var week3: [Curriculum]?
    var week4: [Curriculum]?
    var week5: [Curriculum]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        week1  <- map["week1"]
        week2  <- map["week2"]
        week3  <- map["week3"]
        week4  <- map["week4"]
        week5  <- map["week5"]
    }
}
