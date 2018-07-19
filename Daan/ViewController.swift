//
//  ViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/12/7.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var activeTextField:UITextField? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField:UITextField) {
        self.activeTextField = textField
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
