//
//  SignUpViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import KeychainSwift

class FirstSignUpViewController: UIViewController {
    
    var token:Token? = nil
    @IBOutlet weak var EmailTxt: TextField!
    @IBOutlet weak var PasswordTxt: TextField!
    @IBOutlet weak var NickTxt: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ViewTap(_ sender: Any) {
        self.view.endEditing(false)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! SecondSignUpViewController
        destVC.token = self.token
        destVC.Email = self.EmailTxt.text!
        destVC.Password = self.PasswordTxt.text!
        destVC.Nickname = self.NickTxt.text!
    }
    
}

class SecondSignUpViewController: UIViewController {
    
    var token:Token? = nil
    
    var Email:String! = nil
    var Password:String! = nil
    var Nickname:String! = nil
    
    @IBOutlet weak var SchoolAcc: UITextField!
    @IBOutlet weak var SchoolPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func PopViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ViewTap(_ sender: Any) {
        self.view.endEditing(false)
    }
    
    @IBAction func RegisterTouch(_ sender: Any) {
        let register = Register(email: Email, password: Password, user_group: "student", school_account: SchoolAcc.text!, school_pwd: SchoolPass.text!, nick: Nickname)
        Api().register(register) { (result) in
            switch result{
            case .success(let token):
                self.token = token
                print("Got token:\(token)")
                let keychain = KeychainSwift()
                keychain.set(self.Email, forKey: "account")
                keychain.set(self.Password, forKey: "password")
                print("Keychain set")
                print("Calling performSegue ID:MainSegue")
                self.performSegue(withIdentifier: "MainSegue", sender: self)
            case .apiError(let apiError):
                let alert = UIAlertController(title: NSLocalizedString("API_ERROR_TITLE", comment:"API Error message on title"), message: apiError.error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                    print("Api Error alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
            case .networkError(let netError):
                let alert = UIAlertController(title: NSLocalizedString("CONN_ERROR_TITLE", comment:"Connection Error message on title"), message: netError.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                    print("Alamofire Error alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainSegue" {
            print("Preparing MainSegue")
            let navC = segue.destination as? UINavigationController
            let destVC = navC?.topViewController as! MainViewController
            destVC.token = self.token
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
