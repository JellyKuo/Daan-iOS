//
//  AttitudeTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class AttitudeTableViewController: UITableViewController {
    
    var token:Token? = nil
    var attitudeStatus:AttitudeStatus? = nil
    
    @IBOutlet weak var SmallCiteLab: UILabel!
    @IBOutlet weak var MiddleCiteLab: UILabel!
    @IBOutlet weak var BigCiteLab: UILabel!
    @IBOutlet weak var SmallFaultLab: UILabel!
    @IBOutlet weak var MiddleFaultLab: UILabel!
    @IBOutlet weak var BigFaultLab: UILabel!
    
    var activityInd:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityInd = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityInd.color = UIColor.gray
        let barButton = UIBarButtonItem(customView: activityInd)
        navigationItem.rightBarButtonItem = barButton
        activityInd.startAnimating()
        
        GetData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let status = attitudeStatus?.status{
            return status.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AttitudeTableViewCell"
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AttitudeTableViewCell
            else{
                fatalError("The dequeued cell is not an instance of AttitudeTableViewCell")
        }
        let status = attitudeStatus?.status![indexPath.row]
        cell.dateLab.text = status?.date
        cell.descLab.text = status?.text
        cell.statusLab.text = status?.item
        
        if let status = status?.item
        {
            if(status.range(of: "嘉獎") != nil ||
                status.range(of: "小功") != nil ||
                status.range(of: "大功") != nil ){
                cell.statusLab.textColor = UIColor(hex:"5cb85c")
            }
            else if(status.range(of: "警告") != nil){
                cell.statusLab.textColor = UIColor(hex:"cc9933")
            }
            else if(status.range(of: "小過") != nil ||
                status.range(of: "大過") != nil ){
                cell.statusLab.textColor = UIColor.red
            }
        }
        return cell
    }
    
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
    
    func GetData() {
        //TODO: Refactor this API call
        guard let token = self.token else {
            let alert = UIAlertController(title: NSLocalizedString("ERROR_TITLE", comment:"Error message on title"), message: "Token is nil. App will quit for dump", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                print("Token nil alert happened")
            }))
            self.present(alert, animated: true, completion: { fatalError("Token should not be nil at this point") })
            return
        }
        Api().getAttitudeStatus(token) { result in
            switch result{
                case .success(let attitudeStatus):
                    self.attitudeStatus = attitudeStatus
                    DispatchQueue.main.async {
                        self.reloadCount()
                        self.tableView.reloadData()
                        self.activityInd.stopAnimating()
                    }
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

        /*
        let req = ApiRequest(path: "attitudestatus", method: .get, token: self.token)
        req.request {(res,apierr,alaerr) in
            if let result = res {
                self.attitudeStatus = AttitudeStatus(JSON: result)
                self.reloadCount()
                self.tableView.reloadData()
                self.activityInd.stopAnimating()
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
    
    func reloadCount() {
        guard let count = attitudeStatus?.count else{
            fatalError("Called reloadCount but count is null")
        }
        SmallCiteLab.text = count.smallcite != nil ? String(count.smallcite!) : "?"
        MiddleCiteLab.text = count.middlecite != nil ? String(count.middlecite!) : "?"
        BigCiteLab.text = count.bigcite != nil ? String(count.bigcite!) : "?"
        SmallFaultLab.text = count.smallfault != nil ? String(count.smallfault!) : "?"
        MiddleFaultLab.text = count.middlefault != nil ? String(count.middlefault!) : "?"
        BigFaultLab.text = count.bigfault != nil ? String(count.bigfault!) : "?"
        
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
