//
//  Error.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation

struct ApiError: Codable {
    let code: Int
    let error: String
}
