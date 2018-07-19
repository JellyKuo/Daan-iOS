//
//  CarnivalViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2018/4/12.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import UIKit

class CarnivalViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var scrView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrView.minimumZoomScale = 1.0
        scrView.maximumZoomScale = 6.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
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
