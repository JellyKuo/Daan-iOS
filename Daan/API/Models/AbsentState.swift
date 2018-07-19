//
//  AbsentState.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/14.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import ObjectMapper

struct AbsentState: Mappable {
    var date: String?
    var type: String?
    var cls: String?  //class
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        date   <- map["date"]
        type   <- map["type"]
        cls    <- map["class"]
    }
    
    static func mapToArray(JSON:String) -> [AbsentState]? {
        return nil
    }
}
