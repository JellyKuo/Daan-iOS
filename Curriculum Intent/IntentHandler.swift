//
//  IntentHandler.swift
//  Curriculum Intent
//
//  Created by 郭東岳 on 2018/9/18.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        guard intent is NextClassIntent else{
            fatalError("[IntentHandler] Unhandled intent type: \(intent)")
        }
        return NextClassIntentHandler()
    }
    
}
