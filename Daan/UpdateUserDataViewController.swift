//
//  UpdateUserDataViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/12/13.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import KeychainSwift

class UpdUsrAuthViewController: UIViewController {
    
    var token:Token? = nil
    
    @IBOutlet weak var passTxt: TextField!
    
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
        view.endEditing(false)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "UpdatedDataSegue" {
            let keychain = KeychainSwift()
            if keychain.get("password") == passTxt.text{
                return true
            }
            else{
                let alert = UIAlertController(title: NSLocalizedString("AuthError", comment: "Authenticate Error"), message: NSLocalizedString("PwdNotMatch", comment: "Password does not match"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    print("Auth Error alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdatedDataSegue"{
            let destVC = segue.destination as! UpdatedDataViewController
            destVC.oldPwd = passTxt.text
            destVC.token = token
        }
    }
    
}

class UpdatedDataViewController: UIViewController {
    
    var token:Token? = nil
    var oldPwd:String? = nil
    
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var nickTxt: TextField!
    @IBOutlet weak var schoolPwdTxt: TextField!
    @IBOutlet weak var newPwTxt: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Pop() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ViewTap(_ sender: Any) {
        view.endEditing(false)
    }
    
    @IBAction func UpdateTap() {
        let email = emailTxt.text!
        let nick = nickTxt.text!
        let newPwd = newPwTxt.text!
        let schoolPwd = schoolPwdTxt.text!
        /*
        let req = ApiRequest(path: "actmanage/updateinfo", method: .put, params: ["password":oldPwd!,"new_school_pwd":schoolPwd,"new_nick":nick,"new_password":newPwd,"new_email":email])
        req.request {(res,apierr,alaerr) in
            if let result = res {
                print("Got result: \(result)")
                
            }
            else if let apiError = apierr{
                let alert = UIAlertController(title: NSLocalizedString("API_ERROR_TITLE", comment:"API Error message on title"), message: apiError.error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                    print("Api Error alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else if let alamoError = alaerr{
                let alert = UIAlertController(title: NSLocalizedString("CONN_ERROR_TITLE", comment:"Connection Error message on title"), message: alamoError.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                    print("Alamofire Error alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
 */
        
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
