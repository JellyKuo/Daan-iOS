//
//  Label.swift
//  Daan
//
//  Created by 郭東岳 on 2018/2/10.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import UIKit

@IBDesignable
class Label: UILabel {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBInspectable var masksToBounds: Bool = true{
        didSet{
            self.layer.masksToBounds = masksToBounds
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}

