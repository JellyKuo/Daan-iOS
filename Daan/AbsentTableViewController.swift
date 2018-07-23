//
//  AbsentTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/14.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import ObjectMapper  //TODO: Split array mapping to mapper

class AbsentTableViewController: UITableViewController {
    
    var token:Token? = nil
    var absentState:[AbsentState]? = nil
    var count = [0,0,0,0,0,0]
    
    @IBOutlet weak var SickLab: UILabel!
    @IBOutlet weak var PersonalLab: UILabel!
    @IBOutlet weak var LateLab: UILabel!
    @IBOutlet weak var AbsentLab: UILabel!
    @IBOutlet weak var OfficialLab: UILabel!
    @IBOutlet weak var BereavementLab: UILabel!
    
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
        if let states = absentState{
            return states.count
        }
        else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AbsentTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AbsentTableViewCell
            else{
                fatalError("The dequeued cell is not an instance of AbsentTableViewCell")
        }
        let state = absentState![indexPath.row]
        cell.dateLab.text = state.date
        cell.classLab.text = "第" + state.cls! + "節"
        
        if let type = state.type
        {
            if(type.range(of: "遲") != nil){
                cell.typeLab.textColor = UIColor(hex:"cc9933")
                cell.typeLab.text = NSLocalizedString("ABS_LATE", comment: "Absent type late")
                
            }
            else if(type.range(of: "病") != nil){
                cell.typeLab.textColor = UIColor(hex:"3333cc")
                cell.typeLab.text = NSLocalizedString("ABS_SICK", comment: "Absent type sick")
            }
            else if(type.range(of: "事") != nil){
                cell.typeLab.text = NSLocalizedString("ABS_PERSONAL", comment: "Absent type personal")
            }
            else if(type.range(of: "曠") != nil ||
                type.range(of: "缺") != nil ){
                cell.typeLab.textColor = UIColor.red
                cell.typeLab.text = NSLocalizedString("ABS_ABSENT", comment: "Absent type generic absent or skip")
            }
            else if(type.range(of: "公") != nil){
                cell.typeLab.textColor = UIColor.blue
                cell.typeLab.text = NSLocalizedString("ABS_OFFICIAL", comment: "Absent type official")
            }
            else if(type.range(of: "喪") != nil){
                cell.typeLab.textColor = UIColor.green
                cell.typeLab.text = NSLocalizedString("ABS_BEREAVEMENT", comment: "Absent type bereavement")
            }
            else{
                cell.typeLab.text = state.type
            }
        }
        
        LateLab.text = String(count[0])
        SickLab.text = String(count[1]) + "分"
        PersonalLab.text = String(count[2])
        OfficialLab.text = String(count[3])
        AbsentLab.text = String(count[4])
        BereavementLab.text = String(count[5])
        
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
        // TODO: Refactor this API call
        guard let token = self.token else{
            fatalError("Toke is nil")
        }
        Api().getAbsent(token) { result in
            switch result{
                case .success(let absent):
                    self.absentState = absent
                    for state in self.absentState!{
                        switch state.type!{
                        case "遲":
                            self.count[0] += 1
                            break
                        case "病":
                            self.count[1] += 1
                            break
                        case "事":
                            self.count[2] += 1
                            break
                        case "公":
                            self.count[3] += 1
                            break
                        case "缺":
                            self.count[4] += 1
                            break
                        case "曠":
                            self.count[4] += 1
                            break
                        case "喪":
                            self.count[5] += 1
                            break
                        default:
                            print("I cant find \(state.type!) in the list, not counting")
                            break;
                        }
                    }
                    self.tableView.reloadData()
                    self.activityInd.stopAnimating()
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
        let req = ApiRequest(path: "absentstate", method: .get, token: self.token)
        req.requestArr {(res,apierr,alaerr) in
            if let result = res {
                self.absentState = Mapper<AbsentState>().mapArray(JSONArray: result)
                for state in self.absentState!{
                    switch state.type!{
                    case "遲":
                        self.count[0] += 1
                        break
                    case "病":
                        self.count[1] += 1
                        break
                    case "事":
                        self.count[2] += 1
                        break
                    case "公":
                        self.count[3] += 1
                        break
                    case "缺":
                        self.count[4] += 1
                        break
                    case "曠":
                        self.count[4] += 1
                        break
                    case "喪":
                        self.count[5] += 1
                        break
                    default:
                        print("I cant find \(state.type!) in the list, not counting")
                        break;
                    }
                }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
