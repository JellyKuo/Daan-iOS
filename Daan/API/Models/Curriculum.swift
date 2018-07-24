//
//  Curriculum.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/18.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation

struct Curriculum: Codable {
    let start: String?
    let end: String?
    let subject: String?
    let teacher: String?
}

struct CurriculumWeek: Codable {
    let week1: [Curriculum]
    let week2: [Curriculum]
    let week3: [Curriculum]
    let week4: [Curriculum]
    let week5: [Curriculum]
}
