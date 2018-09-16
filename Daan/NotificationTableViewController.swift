//
//  NotificationTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2018/3/3.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseMessaging

class NotificationTableViewController: UITableViewController {
    
    @IBOutlet weak var allowNoti: UISwitch!
    
    var userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allowNoti.setOn(UIApplication.shared.isRegisteredForRemoteNotifications, animated: true)
        print("Notification remote register now state \(UIApplication.shared.isRegisteredForRemoteNotifications)")
        
        //Moved refreshTopic to viewDidAppear because changing the accessory of cell before viewDidAppear will be discarded
        //refreshTopic()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //This must be called on viewDidAppear
        refreshTopic()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func togAllowNoti(_ sender: Any) {
        if !allowNoti.isOn {
            UIApplication.shared.unregisterForRemoteNotifications()
            print("Unregister from remote notification, now state \(UIApplication.shared.isRegisteredForRemoteNotifications)")
        }
        else{
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
                            DispatchQueue.main.async {
                                application.registerForRemoteNotifications()
                                print("Registred from remote notification, now state \(application.isRegisteredForRemoteNotifications)")
                            }
                        }
                        else{
                            print("Notification permission denied")
                            let alert = UIAlertController(title: NSLocalizedString("Failed", comment: "Failed"), message: NSLocalizedString("NOTI_PERM_DENIED_MSG", comment: "Notification permission denied message"), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                                print("Notification Permission Denied alert dismissed!")
                            }))
                            self.present(alert,animated: true,completion: nil)
                        }
                })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            return
        }
        else if indexPath.section == 1{
            let setVal = tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none   // none -> true, checkmark -> false
            switch indexPath.row{
            case 0:
                chgTopic(setVal, topic: .General)
                break
            case 1:
                chgTopic(setVal, topic: .Promotional)
                break
            case 2:
                chgTopic(setVal, topic: .Beta)
                break
            default:
                break
            }
        }
    }
 
    /*
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            return
        }
        //if let cell = tableView.cellForRow(at: indexPath)  {
        //    cell.accessoryType = .none
        //}
        if indexPath.section == 1{
            switch indexPath.row{
            case 0:
                chgTopic(false, topic: .General)
                break
            case 1:
                chgTopic(false, topic: .Promotional)
                break
            case 2:
                chgTopic(false, topic: .Beta)
                break
            default:
                break
            }
        }
    }
 */
    
    func chgTopic(_ reg:Bool,topic:notiTopics) {
        var notiTopics = [String:Bool]()
        if let usrNotiTopics = userDefaults?.dictionary(forKey: "notiTopics") {
            notiTopics = usrNotiTopics as! [String:Bool]
        }
        else{
            notiTopics["General"] = false
            notiTopics["Promo"] = false
            notiTopics["iOSBeta"] = false
        }
        
        if(reg){
            Messaging.messaging().subscribe(toTopic: topic.rawValue)
            print("Subscribed to \(topic.rawValue)")
        }
        else{
            Messaging.messaging().unsubscribe(fromTopic: topic.rawValue)
            print("Unsubscribed from \(topic.rawValue)")
        }
        notiTopics[topic.rawValue] = reg
        userDefaults?.set(notiTopics, forKey: "notiTopics")
        refreshTopic()
    }
    
    func refreshTopic() {
        if let notiTopics = userDefaults?.dictionary(forKey: "notiTopics"){
            print("notiTopics exists in userDefaults, setting checkmark")
            tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.accessoryType = notiTopics["General"] as! Bool ? .checkmark:.none
            tableView.cellForRow(at: IndexPath(row: 1, section: 1))?.accessoryType = notiTopics["Promo"] as! Bool ? .checkmark:.none
            tableView.cellForRow(at: IndexPath(row: 2, section: 1))?.accessoryType = notiTopics["iOSBeta"] as! Bool ? .checkmark:.none
        }
        else{
            print("Can't find notiTopics Dict in userDefaults, leaving all unchecked")
        }
        
    }
    
    internal enum notiTopics:String{
        case General = "General";
        case Promotional = "Promo";
        case Beta = "iOSBeta"
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
    
}
