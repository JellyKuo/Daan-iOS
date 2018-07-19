//
//  DebugViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2018/6/3.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func t1(_ sender: Any) {
        Api.api.login(account: "jellykuo1234@gmail.com", password: "jellykuo0815", completion: { apiRes in
            print("DBGVC \(apiRes.apiError?.error ?? "ErrNil")")
            print("DBGVC \(apiRes.netError?.localizedDescription ?? "netNil") NET NIL")
            print("DebugVC \(apiRes.result?.token ?? "nil")")
        })
    }

    @IBAction func t2(_ sender: Any) {
        //0print(Api.api.token)
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
