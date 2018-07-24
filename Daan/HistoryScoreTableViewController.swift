//
//  HistoryScoreTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/17.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class HistoryScoreTableViewController: UITableViewController, HistoryScoreViewControllerDelegate {
    
    var token:Token? = nil
    var upHistoryScore:[HistoryScore]? = nil
    var downHistoryScore:[HistoryScore]? = nil
    var historyScore:[CombinedHistoryScore]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetData(grade: 1)
        
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
        //TODO: Handling mismatched list
        if let uHS = upHistoryScore{
            return uHS.count + 1
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "HistoryScoreCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HistoryScoreTableViewCell
            else{
                fatalError("The dequeued cell is not an instance of HistoryScoreTableViewCell")
        }
        if(indexPath.row == 0){
            cell.subjectLab.text = NSLocalizedString("SUBJECT", comment:"Subject text")
            cell.creditLab.text = NSLocalizedString("CREDIT", comment:"Credit represent the point get when passes, text")
            cell.typeLab.text = NSLocalizedString("TYPE", comment:"Type text")
            cell.upLab.text = NSLocalizedString("UP_SEMESTER", comment:"1st semester text")
            cell.downLab.text = NSLocalizedString("DOWN_SEMESTER", comment:"2nd semester text")
            return cell
        }
        //TODO: Handling mismatched list
        if upHistoryScore == nil || upHistoryScore!.count == 0{
            print("There's no item inside upScore, exiting without any content in cell")
            return cell
        }
        
        let uScore = upHistoryScore![indexPath.row - 1]
        cell.subjectLab.text = uScore.subject
        cell.typeLab.text = uScore.type
        
        cell.creditLab.text = uScore.credit
        cell.upLab.text = uScore.score != nil ? String(uScore.score!) : "X"
        
        if downHistoryScore == nil || downHistoryScore!.count == 0{
            print("Got a upScore, but down seems to be empty or nil, skipping with ?")
            cell.downLab.text = "?"
            return cell
        }
        let dScore = downHistoryScore![indexPath.row - 1]
        cell.downLab.text = dScore.score != nil ? String(dScore.score!) : "X"
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
    
    func GetData(grade:Int) {
        upHistoryScore = nil
        downHistoryScore = nil

        guard let token = self.token else {
            fatalError("Token should not be nil")
        }
        Api().getHistoryScore(token, grade: grade, semester: 1) { result in
            switch result{
            case .success(let upHistoryScore):
                self.upHistoryScore = upHistoryScore
                self.refreshTable()
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

        Api().getHistoryScore(token, grade: grade, semester: 2) { result in
            switch result{
            case .success(let downHistoryScore):
                self.downHistoryScore = downHistoryScore
                self.refreshTable()
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
        let upReq = ApiRequest(path: "scorequery/historyscore/"+String(grade)+"/1", method: .get, token: self.token)
        let downReq = ApiRequest(path: "scorequery/historyscore/"+String(grade)+"/2", method: .get, token: self.token)
        upReq.requestArr {(res,apierr,alaerr) in
            if let result = res {
                self.upHistoryScore = Mapper<HistoryScore>().mapArray(JSONArray: result)
                self.refreshTable()
                //self.tableView.reloadData()
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
        downReq.requestArr {(res,apierr,alaerr) in
            if let result = res {
                self.downHistoryScore = Mapper<HistoryScore>().mapArray(JSONArray: result)
                self.refreshTable()
                //self.tableView.reloadData()
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
    
    func refreshTable(){
        if upHistoryScore != nil && downHistoryScore != nil{
            print("Both request is filled! Reload table's data")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        else{
            print("refreshTable called, but one of the request is not completed yet")
            return
        }
        
        //TODO: Handling mismatched list
        /*
        guard var uHS = upHistoryScore,var dHS = downHistoryScore else{
            print("refreshTable called, but one of the request is not completed yet")
            return
        }
        
        historyScore = Array<CombinedHistoryScore>()
        if(uHS.count>dHS.count){
            for (uIndex,uItem) in uHS.enumerated(){
                for (dIndex,dItem) in dHS.enumerated(){
                    if(uItem.subject == dItem.subject){
                        var cHS = CombinedHistoryScore()
                        cHS.subject = uItem.subject
                        cHS.qualify = uItem.qualify
                        cHS.credit = uItem.credit
                        cHS.type = uItem.type
                        cHS.scoreUp = uItem.score
                        cHS.scoreDown = dItem.score
                        historyScore?.append(cHS)
                        uHS.remove(at: uIndex)
                        dHS.remove(at: dIndex)
                        break
                    }
                }
            }
            */
        }
    
    func changeGrade(_ id: Int?) {
        GetData(grade: id!)
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
    
    struct CombinedHistoryScore {
        var subject: String?
        var type: String?
        var credit: Int?
        var scoreUp: Int?
        var scoreDown: Int?
        var qualify: Int?
}


