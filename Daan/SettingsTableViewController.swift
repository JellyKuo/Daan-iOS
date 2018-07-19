//
//  SettingsTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/12/9.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import KeychainSwift
import MessageUI
import SafariServices
import FirebaseMessaging  //Remove on production
import Crashlytics  //Remove on production

class SettingsTableViewController: UITableViewController,MFMailComposeViewControllerDelegate, SFSafariViewControllerDelegate {
    
    var token:Token? = nil
    
    let userDefaults:UserDefaults = UserDefaults(suiteName: "group.com.Jelly.Daan")!
    weak var displayNameDelegate:displayNameDelegate?
    @IBOutlet weak var mainDispSegment: UISegmentedControl!
    @IBOutlet weak var crhRepSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appType.build == .TestFlight {
            //Lock it up to prevent user turn off crash reporting in TestFlight
            //In AppDelegate, TF users are forced to join crash reporting no matter what
            crhRepSwitch.isEnabled = false
            crhRepSwitch.setOn(true, animated: false)
        }
        else{
            crhRepSwitch.setOn(userDefaults.bool(forKey: "crashReport"), animated: true)
        }
        
        mainDispSegment.selectedSegmentIndex = userDefaults.bool(forKey: "displayNickname") ? 0 : 1 //0:Nick, 1:Full
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row{
            case 0:
                #if DEBUG
                    let alert = UIAlertController(title: NSLocalizedString("FAILED_TITLE", comment: "Failed message on title"), message: NSLocalizedString("UPDATE_USER_DATA_NOT_AVAILABLE_MSG", comment: "Prompts user that update user data is currently broken") + "\n\n[DEBUG]", preferredStyle: .alert)
                #else
                    let alert = UIAlertController(title: NSLocalizedString("FAILED_TITLE", comment: "Failed message on title"), message: NSLocalizedString("UPDATE_USER_DATA_NOT_AVAILABLE_MSG", comment: "Prompts user that update user data is currently broken"), preferredStyle: .alert)
                #endif
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                    print("Update user data broken alert occured")
                    #if DEBUG
                        self.performSegue(withIdentifier: "UpdateUserDataSegue", sender: self)
                    #endif
                }))
                present(alert, animated: true, completion: nil)
                //performSegue(withIdentifier: "UpdateUserDataSegue", sender: self)
                break
            case 2:
                openUrl("https://status.dacsc.club",useSFShow: true)
                break
            case 3:
                if MFMailComposeViewController.canSendMail() {
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    
                    // Configure the fields of the interface.
                    composeVC.setToRecipients(["jellykuo1234@gmail.com"])
                    // Present the view controller modally.
                    present(composeVC, animated: true, completion: nil)
                }
                else{
                    print("Mail services are not available, using mailto")
                    openUrl("mailto:jellykuo1234@gmail.com", useSFShow: false)
                }
                break

            case 7:
                clearCurriculum(supressAlert: false)
                break;
            case 8:
                openUrl("itms-apps://itunes.apple.com/app/id1316911750", useSFShow: false)
            default:
                break;
            }
        }
            
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                logout(supressAlert: false)
                break;
            case 1:
                resetApp()
            default:
                break;
            }
        }
            
            //Remove on production
        else if indexPath.section == 2 {
            switch indexPath.row{
            case 0:
                guard let usersDefault = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
                    fatalError("Cannot init userdefaults with suiteName group.com.Jelly.Daan")
                }
                usersDefault.removeObject(forKey: "SplashDismiss")
                break
            case 1:
                guard let usersDefault = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
                    fatalError("Cannot init userdefaults with suiteName group.com.Jelly.Daan")
                }
                if let JSON = usersDefault.string(forKey: "curriculumJSON"){
                    let alert = UIAlertController(title: "Cached curriculum", message: JSON, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                        UIPasteboard.general.string = JSON
                    }))
                    self.present(alert,animated: true,completion: nil)
                }
                break
            case 2:
                if let tk = token?.token{
                    let alert = UIAlertController(title: "API Token", message: tk, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                        UIPasteboard.general.string = tk
                    }))
                    self.present(alert,animated: true,completion: nil)
                }
                break
            case 3:
                let alert = UIAlertController(title: "FCM Token", message: Messaging.messaging().fcmToken, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                    UIPasteboard.general.string = Messaging.messaging().fcmToken
                }))
                self.present(alert,animated: true,completion: nil)
                break
            default:
                break
            }
        }
            
            //Remove on production
        else if indexPath.section == 3{
            #if DEBUG
            Crashlytics.sharedInstance().crash()
            #endif
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        #if DEBUG
        return 4
        #else
        return 2
        #endif
    }
    
    @IBAction func mainDispSegmentChg(_ sender: Any) {
        userDefaults.set(mainDispSegment.selectedSegmentIndex == 0 , forKey: "displayNickname")  //0:Nick, 1:Full
        displayNameDelegate?.displaySwitched()
    }
    
    @IBAction func crhRepToggle(_ sender: Any) {
        userDefaults.set(crhRepSwitch.isOn, forKey: "crashReport")
    }
    
    func clearCurriculum(supressAlert:Bool){
        guard let usersDefault = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
            fatalError("Cannot init userdefaults with suiteName group.com.Jelly.Daan")
        }
        usersDefault.removeObject(forKey: "curriculumJSON")
        if(usersDefault.object(forKey: "curriculumJSON") == nil && !supressAlert){
            let alert = UIAlertController(title: NSLocalizedString("SUCCESS_TITLE", comment: "Success message on title"), message: NSLocalizedString("CLEAR_CURRICULUM_SUCCESS_MSG", comment: "Curriculum cache cleared successful message"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                print("Curriculum data cleared alert dismissed!")
            }))
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    func logout(supressAlert:Bool) {
        let keychain = KeychainSwift()
        keychain.clear()
        if(keychain.get("account") == nil&&keychain.get("password") == nil && !supressAlert){
            let alert = UIAlertController(title: NSLocalizedString("SUCCESS_TITLE", comment: "Success message on title"), message: NSLocalizedString("LOGOUT_SUCCESS_MSG", comment: "Logout successful message"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                print("Logout success! Clearing nav stack")
                guard let navC = self.navigationController else{
                    fatalError("Cannot get nav controller")
                }
                navC.popToRootViewController(animated: false)
                if let mainVC = navC.childViewControllers[0] as? MainViewController{
                    mainVC.autoLogin()
                }
            }))
            self.present(alert,animated: true,completion:nil)
        }
    }
    
    func resetApp() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        guard let usersDefault = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
            fatalError("Cannot init userdefaults with suiteName group.com.Jelly.Daan")
        }
        usersDefault.removePersistentDomain(forName: "group.com.Jelly.Daan")
        UserDefaults.standard.synchronize()
        logout(supressAlert: true)
        let alert = UIAlertController(title: NSLocalizedString("SUCCESS_TITLE", comment: "Success message on title"), message: NSLocalizedString("RESET_SUCCESS_MSG", comment: "Application reset successful message"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
            print("Reset success! Clearing nav stack")
            guard let navC = self.navigationController else{
                fatalError("Cannot get nav controller")
            }
            navC.popToRootViewController(animated: false)
            if let mainVC = navC.childViewControllers[0] as? MainViewController{
                mainVC.autoLogin()
            }
        }))
        self.present(alert,animated: true,completion:nil)
    }
    
    private func openUrl(_ urlString:String, useSFShow:Bool) {
        let url = URL(string: urlString)!
        if #available(iOS 11.0, *), useSFShow {
            print("iOS 11, SFSafariView here we go")
            let config = SFSafariViewController.Configuration()
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.delegate = self
            present(vc, animated: true)
        }
        else if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }
     
     /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
     
     /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
     
     /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
     
     /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
     
     /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "UpdateUserDataSegue"?:
            let navC = segue.destination as? UINavigationController
            let updateUserDataVC = navC?.viewControllers.first as? UpdUsrAuthViewController
            updateUserDataVC?.token = token
        default:
            break
        }
    }
    
}

protocol displayNameDelegate:class {
    func displaySwitched()
}
