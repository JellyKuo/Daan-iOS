//
//  CurriculumTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/18.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class CurriculumTableViewController: UITableViewController {
    
    var curriculums:[Curriculum]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hiding the unnecessary cell splitter
        tableView.tableFooterView = UIView(frame: .zero)
        
        //This part is to fix the problem that the tableview will be under the nav bar
        //This issue seems to persist only on small device running iOS 11 BELOW
        //On iOS 11 Large Nav Title mode and large phones, this workaround glitches
        
        if #available(iOS 11, *){
            print("iOS 11 or above is detected! No TableView offset")
        }
        else{
            if let rect = self.navigationController?.navigationBar.frame {
                let y = rect.size.height + rect.origin.y
                self.tableView.contentInset = UIEdgeInsets.init( top: y, left: 0, bottom: 0, right: 0)
                print("iOS 11 below is detected! TableView offset to \(y)")
            }
        }
        
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
        guard let count = curriculums?.count else{
            return 0
        }
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CurriculumCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CurriculumTableViewCell
            else{
                fatalError("The dequeued cell is not an instance of CurriculumTableViewCell")
        }
        let curriculum = curriculums![indexPath.row]
        cell.startLab.text = curriculum.start
        cell.endLab.text = curriculum.end
        cell.subjectLab.text = curriculum.subject
        cell.teacherLab.text = curriculum.teacher
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
