//
//  Register.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation

struct Register: Codable {
    let email: String
    let password: String
    let user_group:String
    let school_account:String
    let school_pwd:String
    let nick:String
}
