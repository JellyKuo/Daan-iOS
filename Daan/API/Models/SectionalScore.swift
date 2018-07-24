//
//  SectionalScore.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/15.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation

struct SectionalScore: Codable {
    let subject: String
    let first_section: Int?
    let second_section: Int?
    let last_section: Int?
    let performance: Int?
    let average: Int?
}
