//
//  Button.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/29.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

@IBDesignable
class Button: UIButton {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
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
    
    @IBInspectable var animated: Bool = false{
        didSet{
            if animated {
                self.startAnimatingPressActions()
            }
        }
    }
}

// MARK: UIButton extension

extension UIButton{
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        if #available(iOS 10.0, *) {
            ImpactFeedback.sharedInstance.prepare(style: .medium)
            ImpactFeedback.sharedInstance.impact()
            ImpactFeedback.sharedInstance.prepare(style: .light)
        }
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9))
    }
    
    @objc private func animateUp(sender: UIButton) {
        if #available(iOS 10.0, *) {
            if ImpactFeedback.sharedInstance.style == UIImpactFeedbackStyle.light{
                ImpactFeedback.sharedInstance.impact()
                ImpactFeedback.sharedInstance.release()
            }
            else{
                ImpactFeedback.sharedInstance.prepare(style: .light)
                ImpactFeedback.sharedInstance.impact()
                ImpactFeedback.sharedInstance.release()
            }
        }
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
        }, completion: nil)
    }
}
