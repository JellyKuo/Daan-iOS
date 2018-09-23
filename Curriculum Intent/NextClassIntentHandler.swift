//
//  NextClassIntentHandler.swift
//  Curriculum Intent
//
//  Created by 郭東岳 on 2018/9/20.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import Foundation

class NextClassIntentHandler: NSObject, NextClassIntentHandling{
    func handle(intent: NextClassIntent, completion: @escaping (NextClassIntentResponse) -> Void) {
        completion(NextClassIntentResponse.success(nextClass: "CLASS NAME HERE"))
    }
    
    func confirm(intent: NextClassIntent, completion: @escaping (NextClassIntentResponse) -> Void) {
        completion(NextClassIntentResponse(code: .ready, userActivity: nil))
    }
}
