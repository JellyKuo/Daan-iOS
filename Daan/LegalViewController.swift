//
//  LicenseViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2018/2/28.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import UIKit
import SafariServices

class LegalViewController: UIViewController,SFSafariViewControllerDelegate {
    
    @IBOutlet weak var txtView: UITextView!
    var legal = ""
    var urlStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if legal != ""{
            //TextView scrolling will bug on first offset
            //Locking scroll here, unlock it in viewDidAppear
            txtView.isScrollEnabled = false
            txtView.text = legal
        }
        else {
            //If no delay is applied, Safari View Controller will be blank
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.ActionTap(self)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //Re enable scrolling
        txtView.scrollRangeToVisible(NSRange(location: 0,length: 1))
        txtView.isScrollEnabled = true
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ActionTap(_ sender: Any) {
        guard let url = URL(string: urlStr) else {
            print("No url configured")
            if legal == ""{
                navigationController?.popViewController(animated: false)
            }
            return
        }
        
        if #available(iOS 11.0, *) {
            SFSafariShow(url)
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @available(iOS 11.0, *)
    func SFSafariShow(_ url:URL) {
        let config = SFSafariViewController.Configuration()
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        if legal == ""{
            navigationController?.popViewController(animated: false)
        }
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
