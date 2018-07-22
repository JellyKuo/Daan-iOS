//
//  MainViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/8.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import KeychainSwift
import FirebaseMessaging

class MainViewController: UIViewController,displayNameDelegate {
    
    var token:Token? {
        didSet{
            print("Did set token in MainViewController")
            tokenDelegate?.tokenChanged(token: self.token)
        }
    }
    var userInfo:UserInfo?
    let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan")!
    weak var tokenDelegate:tokenDelegate?
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var nextClassLab: UILabel!
    @IBOutlet weak var nextClassDescLab: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        autoLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            print("iOS 11 detected! Enabling large navbar title")
        } else {
            print("iOS 11 is not present! Ignoring large navbar title")
        }
        
        WelcomeSplash()
        NextClassRefresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserInfo() {
        // FIXME: Unsafe unwrap for testing purposes only
        // This force unwrap is UNSAFE
        // EXPERIMENTAL AF
        // FIXME: Refactor this API call
        Api().getUserInfo(token!,completion:  { (result) in
            switch result{
            case .success(let userInfo):
                self.userInfo = userInfo
                self.userDefaults.set(self.userInfo?.name, forKey: "name")
                self.userDefaults.set(self.userInfo?.nick, forKey: "nickname")
                self.displaySwitched()
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
        })
        
        // Legacy API Code
        /*
        let req = ApiRequest(path: "actmanage/getUserInfo", method: .get, token: self.token)
        req.request {(res,apierr,alaerr) in
            if let result = res {
                self.userInfo = UserInfo(JSON: result)
                self.userDefaults.set(self.userInfo?.name, forKey: "name")
                self.userDefaults.set(self.userInfo?.nick, forKey: "nickname")
                self.displaySwitched()
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
    
    func autoLogin(){
        let keychain = KeychainSwift()
        guard let account = keychain.get("account"),let password = keychain.get("password") else{
            print("Account and password does not exist in keychain, perform welcome segue")
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "WelcomeSegue", sender: self)
            }
            return
        }
        if(token != nil){
            getUserInfo()
            return
        }
        
        // FIXME: Refactor this API call
        
        let login = Login(account: account, password: password)
        Api().login(login, completion: { (result) in
            switch result{
            case .success(let token):
                self.token = token
                self.getUserInfo()
            case .apiError(let apiError):
                let alert = UIAlertController(title: NSLocalizedString("API_ERROR_TITLE", comment:"API Error message on title"), message: apiError.error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                    print("Api Error alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
                keychain.clear()
                print("Login has API failed! Clearing keychain and performing welcome segue")
                DispatchQueue.main.async(){
                    self.performSegue(withIdentifier: "WelcomeSegue", sender: self)
                }
            case .networkError(let netError):
                let alert = UIAlertController(title: NSLocalizedString("CONN_ERROR_TITLE", comment:"Connection Error message on title"), message: netError.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                    print("Alamofire Error alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        })
        
        /*
         let req = ApiRequest(path: "actmanage/login", method: .post, params: ["account":account,"password":password])
         req.request {(res,apierr,alaerr) in
         if let result = res {
         self.token = Token(JSON: result)
         self.tokenDelegate?.tokenChanged(token: self.token)
         print("Got result:\(result)")
         self.getUserInfo()
         }
         else if let apiError = apierr{
         let alert = UIAlertController(title: NSLocalizedString("API_ERROR_TITLE", comment:"API Error message on title"), message: apiError.error, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
         print("Api Error alert occured")
         }))
         self.present(alert, animated: true, completion: nil)
         keychain.clear()
         print("Login has API failed! Clearing keychain and performing welcome segue")
         DispatchQueue.main.async(){
         self.performSegue(withIdentifier: "WelcomeSegue", sender: self)
         }
         }
         else if let alamoError = alaerr{
         let alert = UIAlertController(title: NSLocalizedString("CONN_ERROR_TITLE", comment:"Connection Error message on title"), message: alamoError.localizedDescription, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
         print("Alamofire Error alert occured")
         }))
         self.present(alert, animated: true, completion: nil)
         }
         */
        
        
    }
    
    func WelcomeSplash() {
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
            fatalError("Cannot init new UserDefaults with suiteName")
        }
        guard let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            fatalError("Cannot get CFBundleVersion and convert to string")
        }
        if let lastVersion = userDefaults.string(forKey: "lastVersion"){
            if lastVersion == bundleVersion{
                print("App version: \(bundleVersion), not updated")
                return
            }
            else{
                print("App version: \(bundleVersion), updated")
                
                // FIXME: App update detection
                // THIS IS ONLY FOR A SINGLE VERSION UPDATE, SHOULD NOT BE ON PRODUCTION
                
                if userDefaults.object(forKey: "notiTopics") == nil{
                    var notiTopic = [String:Bool]()
                    notiTopic["General"] = true
                    Messaging.messaging().subscribe(toTopic: "General")
                    notiTopic["Promo"] = false
                    if appType.build == .TestFlight{
                        notiTopic["iOSBeta"] = true
                        Messaging.messaging().subscribe(toTopic: "iOSBeta")
                    }
                    else{
                        notiTopic["iOSBeta"] = false
                    }
                    userDefaults.set(notiTopic, forKey: "notiTopics")
                }
            }
        }
        else{
            print("App version: \(bundleVersion), new launch")
            
            // FIXME: Notification topics subscription
            // THIS IS ONLY FOR A SINGLE VERSION UPDATE, SHOULD NOT BE ON PRODUCTION
            
            if userDefaults.object(forKey: "notiTopics") == nil{
                var notiTopic = [String:Bool]()
                notiTopic["General"] = true
                Messaging.messaging().subscribe(toTopic: "General")
                notiTopic["Promo"] = false
                if appType.build == .TestFlight{
                    notiTopic["iOSBeta"] = true
                    Messaging.messaging().subscribe(toTopic: "iOSBeta")
                }
                else{
                    notiTopic["iOSBeta"] = false
                }
                userDefaults.set(notiTopic, forKey: "notiTopics")
            }
        }
        performSegue(withIdentifier: "SplashSegue", sender: self)
    }
    
    func NextClassRefresh() {
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else {
            fatalError("Cannot init UserDefaults with suiteName group.com.Jelly.Daan")
        }
        if let JSON = userDefaults.string(forKey: "curriculumJSON"), JSON != "" {
            if let curr = CurriculumWeek(JSONString: JSON){
                print("Got curriculum JSON from UserDefaults and mapped to object")
                let currRes = getCurr(currWeek: curr)
                nextClassLab.text = " " + currRes.subject! + " "
            }
        }
        else{
            print("curriculum JSON is empty, prompting to open curriculum")
            nextClassLab.text = " "+NSLocalizedString("CURRICULUM_NOT_CACHED_MSG", comment: "Curriculum cache is not downloaded, tap curriculum to cache")+" "
        }
        
    }
    
    func displaySwitched() {
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else {
            fatalError("Cannot init UserDefaults with suiteName group.com.Jelly.Daan")
        }
        if userDefaults.bool(forKey: "displayNickname") {
            print("Display nickname is true in userDefaults, using nick")
            if let nick = userDefaults.string(forKey: "nickname"){
                if self.nameLab != nil{
                    self.nameLab.text = nick
                }
            }
        }
        else{
            print("Display nickname is false or not set in userDefaults, using full name")
            if let name = userDefaults.string(forKey: "name"){
                if self.nameLab != nil{
                    self.nameLab.text = name
                }
            }
            
        }
    }
    
    func getCurr(currWeek:CurriculumWeek) -> Curriculum {
        let date = Date()
        let weekday = Calendar.current.component(.weekday, from: date)
        let index:Int
        let today:Bool
        if weekday <= 6 && weekday >= 2 {
            let hour = Calendar.current.component(.hour, from: date)
            if hour < 16{
                let minute = Calendar.current.component(.minute, from: date)
                if hour == 15 && minute > 10{
                    today = false
                    if weekday != 6{
                        index = weekday - 1
                    }
                    else{
                        index = 0
                        nextClassDescLab.text = NSLocalizedString("MONDAY", comment: "Monday")
                        return currWeek.week1![0]
                    }
                }
                else{
                    index = weekday - 2
                    today = true
                }
            }
            else{
                today = false
                if weekday != 6{
                    index = weekday - 1
                }
                else{
                    index = 0
                    nextClassDescLab.text = NSLocalizedString("MONDAY", comment: "Monday")
                    return currWeek.week1![0]
                }
            }
        }
        else{
            today = false
            index = 0
        }
        
        let res:[Curriculum]?
        switch index {
        case 0:
            res = currWeek.week1
        case 1:
            res = currWeek.week2
        case 2:
            res = currWeek.week3
        case 3:
            res = currWeek.week4
        case 4:
            res = currWeek.week5
        default:
            fatalError("index for Monday to Friday is out of range! Date: \(date), Index: \(index)")
        }
        if let day = res{
            if today{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd "
                let dateStr = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                
                for cls in day{
                    let clsTime = dateFormatter.date(from: dateStr + cls.start!)!
                    if date < clsTime{
                        nextClassDescLab.text = NSLocalizedString("NEXT_CLASS", comment: "Next class in curriculum")
                        return cls
                    }
                }
                fatalError()
                
            }
            else{
                nextClassDescLab.text = NSLocalizedString("TOMORROW", comment: "Tomorrow")
                return day[0]
            }
        }
        else{
            fatalError("result is NIL")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedTableViewSegue"{
            print("Preparing EmbedTableViewSegue")
            let destVC = segue.destination as! MainTableViewController
            self.tokenDelegate = destVC
        }
        else if segue.identifier == "SettingsSegue" {
            print("Preparing SettingsSegue")
            let destVC = segue.destination as! SettingsTableViewController
            destVC.token = self.token
            destVC.displayNameDelegate = self
        }
    }
}

protocol tokenDelegate:class {
    func tokenChanged(token: Token?)
}
