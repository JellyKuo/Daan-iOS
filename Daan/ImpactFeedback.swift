//
//  ImpactFeedback.swift
//  Daan
//
//  Created by 郭東岳 on 2018/7/27.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 10.0, *)
class ImpactFeedback{
    static let sharedInstance:ImpactFeedback = ImpactFeedback()
    var style:UIImpactFeedbackStyle? = nil
    var impactFeedbackGenerator : UIImpactFeedbackGenerator? = nil
    
    private init(){
        print("[Impact] Initialize sharedInstance")
    }
    
    func prepare(style:UIImpactFeedbackStyle) {
        if impactFeedbackGenerator == nil || self.style != style{
            impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
            self.style = style
        }
        impactFeedbackGenerator?.prepare()
        let styleStr:String
        switch style{
        case .heavy:
            styleStr = "heavy"
        case .medium:
            styleStr = "medium"
        case .light:`
            styleStr = "light"
        }
        print("[Impact] Feedback generator prepare \(styleStr)")
    }
    
    func impact() {
        impactFeedbackGenerator?.impactOccurred()
        print("[Impact] Impact")
    }
    
    func release() {
        impactFeedbackGenerator = nil
        style = nil
        print("[Impact] Release generator")
    }
}
