//
//  SplashViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2018/1/30.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var crsReportSwitch: UISwitch!
    
    @IBAction func notiReqPermTap(_ sender: Any) {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {granted, err in
                    if err != nil {
                        fatalError("UNUserNotificationCenter requestAuthorization returned an error! \(String(describing: err))")
                    }
                    if granted{
                        print("Notification permission granted")
                    }
                    else{
                        print("Notification permission denied")
                        let alert = UIAlertController(title: NSLocalizedString("FAILED_TITLE", comment: "Failed message on title"), message: NSLocalizedString("NOTI_PERM_DENIED_MSG", comment: "Notification permission denied message"), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                            print("NotificationPermDenied alert dismissed!")
                        }))
                        self.present(alert,animated: true,completion: nil)
                    }
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        performSegue(withIdentifier: "afterNotiSegue", sender: self)
    }
    
    
    @IBAction func StartBtnTap(_ sender: Any) {
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
            fatalError("Cannot init new UserDefaults with suiteName")
        }
        guard let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            fatalError("Cannot get CFBundleShortVersionString and convert to string")
        }
        print("Set lastVersion to \(bundleVersion)")
        userDefaults.set(bundleVersion, forKey: "lastVersion")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func crsReportTap(_ sender: Any) {
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else {
            fatalError("Cannot init UserDefaults with suiteName group.com.Jelly.Daan")
        }
        userDefaults.set(crsReportSwitch.isOn, forKey: "crashReport")
        print("Setting userDefault key crashReport to \(crsReportSwitch.isOn)")
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
