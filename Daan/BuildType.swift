//
//  BuildType.swift
//  Daan
//
//  Created by 郭東岳 on 2018/5/13.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import Foundation

enum BuildType {
    case Debug
    case TestFlight
    case AppStore
}

struct appType {
    // This is private because the use of 'appConfiguration' is preferred.
    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    
    // This can be used to add debug statements.
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static var build: BuildType {
        if isDebug {
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }
}
