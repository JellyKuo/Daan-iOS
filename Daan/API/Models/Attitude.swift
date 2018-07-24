//
//  File.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation

struct Attitude: Codable {
    let date: String
    let item: String
    let text: String
}

struct AttitudeStatus: Codable {
    let status: [Attitude]
    let count: AttitudeCount
}

struct AttitudeCount: Codable {
    let smallcite: Int
    let smallfault: Int
    let middlecite: Int
    let middlefault: Int
    let bigcite: Int
    let bigfault: Int
}
