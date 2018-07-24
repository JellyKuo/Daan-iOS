//
//  HistoryGrade.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/17.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation

struct HistoryScore: Codable {
    let subject: String
    let type: String
    let credit: String
    let score: Int?
    let qualify: Int?
}
