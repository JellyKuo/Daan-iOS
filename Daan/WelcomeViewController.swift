//
//  WelcomeViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2018/12/22.
//  Copyright © 2018 郭東岳. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if txtJson != nil{
            txtJson.text = UIPasteboard.general.string
        }
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var txtJson: UITextField!
    
    @IBAction func btnCurr_Tap(_ sender: Any) {
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
            fatalError("Cannot init new UserDefaults with suiteName")
        }
        if userDefaults.string(forKey: "curriculumJSON") != nil{
            print("Got curriculum in UserDefaults, load curriculum page")
            performSegue(withIdentifier: "currSegue", sender: self)
        }
        else{
            print("No data stored in UsersDefaults with key curriculumJSON. Asking user to enter one")
            performSegue(withIdentifier: "currCacheSegue", sender: self)
        }
    }
    
    @IBAction func btnCurrCache_Tap(_ sender: Any) {
        let decoder = JSONDecoder()
        do{
            _ = try decoder.decode(CurriculumWeek.self, from: txtJson.text!.data(using: .utf8)!)
            guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
                fatalError("Cannot init new UserDefaults with suiteName")
            }
            userDefaults.set(txtJson.text!, forKey: "curriculumJSON")
            userDefaults.synchronize()
            performSegue(withIdentifier: "currSegue", sender: self)
        }
        catch{
            print("JSON cannot be decoded to object")
            let alert = UIAlertController(title: "Nope", message: "I cannot decode this json, make sure the data is copied correctly", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: nil))
            self.present(alert,animated: true,completion: nil)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "currSegue"{
            let navC = segue.destination as? UINavigationController
            if #available(iOS 11.0, *) {
                navC!.navigationBar.prefersLargeTitles = true
                print("iOS 11 detected! Enabling large navbar title")
            } else {
                print("iOS 11 is not present! Ignoring large navbar title")
            }
        }
       
    }
 

}
