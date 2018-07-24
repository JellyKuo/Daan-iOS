//
//  CalendarTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2018/7/24.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import UIKit

class CalendarTableViewController: UITableViewController {
    
    var calendar = [CalendarEvent]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
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
        return calendar.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CalendarCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CalendarTableViewCell
            else{
                fatalError("The dequeued cell is not an instance of CalendarCell")
        }
        cell.lblStart.text = calendar[indexPath.row].start
        cell.lblEnd.text = calendar[indexPath.row].end
        cell.lblContent.text = calendar[indexPath.row].content
        return cell
    }
    
    func getData(){
        Api().getCalendar { (result) in
            switch result{
            case .success(let calendar):
                self.calendar = calendar
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
