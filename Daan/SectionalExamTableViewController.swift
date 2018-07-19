//
//  SectionalExamTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/15.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import ObjectMapper

class SectionalExamTableViewController: UITableViewController,SectionalExamViewControllerDelegate {

    var token:Token? = nil
    var sectionalScore:[SectionalScore]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetData(semester: 1)
        
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
        if let scores = sectionalScore{
            return scores.count + 1
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SectionalExamCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SectionalExamTableViewCell
            else{
                fatalError("The dequeued cell is not an instance of SectionalExamTableViewCell")
        }
        if(indexPath.row == 0){
            cell.subjectLab.text = "科目"
            cell.lab1.text = "一"
            cell.lab2.text = "二"
            cell.lab3.text = "三"
            cell.lab4.text = "平時"
            cell.lab5.text = "平均"
            return cell
        }
        let score = sectionalScore![indexPath.row - 1]
        
        cell.subjectLab.text = score.subject
        cell.lab1.text = score.first_section != nil ? String(score.first_section!) : "X"
        cell.lab2.text = score.second_section != nil ? String(score.second_section!) : "X"
        cell.lab3.text = score.last_section != nil ? String(score.last_section!) : "X"
        cell.lab4.text = score.performance != nil ? String(score.performance!) : "X"
        cell.lab5.text = score.average != nil ? String(score.average!) : "X"
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
    
    //TODO: Use tableviewheader
    func changeSemester(_ id: Int?) {
        //Delegate from SectionalExamViewController
        //Called when request semester change
        GetData(semester: id!)
    }

    func GetData(semester:Int) {
        let req = ApiRequest(path: "scorequery/sectionalexamscore/"+String(semester), method: .get, token: self.token)
        req.requestArr {(res,apierr,alaerr) in
            if let result = res {
                self.sectionalScore = Mapper<SectionalScore>().mapArray(JSONArray: result)
                self.tableView.reloadData()
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
