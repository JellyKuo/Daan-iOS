//
//  StudyRoomViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/12/15.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import WebKit

class StudyRoomViewController: UIViewController,WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    let url:String
    var myContext = 0
    
    required init?(coder aDecoder: NSCoder) {
        let apiConfig = NSDictionary(contentsOfFile:Bundle.main.path(forResource: "ApiConfig", ofType: "plist")!)
        let apiUrl = apiConfig?.object(forKey: "ApiUrl") as! String
        let apiVersion = apiConfig?.object(forKey: "ApiVersion") as! String
        url = "https://" + apiUrl + "/" + apiVersion + "/seatstate"
        super.init(coder: aDecoder)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.removeFromSuperview()
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
        print("WKWebView created")
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        //progressView.tintColor = view.tintColor
        navigationController?.navigationBar.addSubview(progressView)
        let navigationBarBounds = self.navigationController?.navigationBar.bounds
        progressView.frame = CGRect(x: 0, y: navigationBarBounds!.size.height - 2, width: navigationBarBounds!.size.width, height: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: &myContext)

        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reloadTap(_ sender: Any) {
        webView.reload()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else { return }
        if context != &myContext {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == "estimatedProgress" {
            if let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue {
                progressView.progress = progress;
            }
            return
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
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
