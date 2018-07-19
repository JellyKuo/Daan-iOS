//
//  File.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import ObjectMapper

struct Attitude: Mappable {
    var date: String?
    var item: String?
    var text: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        date  <- map["date"]
        item  <- map["item"]
        text  <- map["text"]
    }
}

struct AttitudeStatus: Mappable {
    var status: [Attitude]?
    var count: AttitudeCount?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        status  <- map["status"]
        count   <- map["count"]
    }
}

struct AttitudeCount: Mappable {
    var smallcite: Int?
    var smallfault: Int?
    var middlecite: Int?
    var middlefault: Int?
    var bigcite: Int?
    var bigfault: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        smallcite    <- map["smallcite"]
        smallfault   <- map["smallfault"]
        middlecite   <- map["middlecite"]
        middlefault  <- map["middlefault"]
        bigcite      <- map["bigcite"]
        bigfault     <- map["bigfault"]
    }
}
