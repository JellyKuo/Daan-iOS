//
//  UIColor.swift
//  Daan
//
//  Created by 郭東岳 on 2017/12/1.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import UIKit

//This extension can let you get the hex value of a existing color
//USAGE: let color = UIColor.red; let hex = color.toHexString
extension UIColor {
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}

//This extension can let you create UIColor with hex color code
//USAGE: let color = UIColor(hex: "ff0000")
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

