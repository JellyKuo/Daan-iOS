//
//  HistoryScoreViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/17.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class HistoryScoreViewController: UIViewController {
    
    var token:Token? = nil
    var grade:Int = 1
    
    //TODO: Use tableviewheader
    //Controls semester change delegate
    weak var delegate:HistoryScoreViewControllerDelegate?
    
    @IBOutlet weak var gradeLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradeLab.text = NSLocalizedString("GRADE_ONE", comment: "1st grade")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChangeGradeTap(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if(grade>1){
                grade -= 1
            }
            else {return}
        case 2:
            if(grade<3){
                grade += 1 }
            else {return}
        default:
            fatalError("The tapped button's id is neither 1 nor 2!")
        }
        
        switch grade {
        case 1:
            gradeLab.text = NSLocalizedString("GRADE_ONE", comment: "1st grade")
        case 2:
            gradeLab.text = NSLocalizedString("GRADE_TWO", comment: "2nd grade")
        case 3:
            gradeLab.text = NSLocalizedString("GRADE_THREE", comment: "3rd grade")
        default:
            print("Grade is not 0, 1, 2. I can't localize it!")
            gradeLab.text = String(grade) + NSLocalizedString("GRADE", comment: "Unknown grade will use this string")
        }
        
        delegate?.changeGrade(self.grade)
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
        if segue.identifier == "HistoryContainerSegue" {
            print("Preparing HistoryContainerSegue")
            let destVC = segue.destination as! HistoryScoreTableViewController
            destVC.token = self.token
            //TODO: Use tableviewheader
            //Set the delegate to SectionalExamTableViewController
            self.delegate = destVC
        }
    }
    
}

protocol HistoryScoreViewControllerDelegate: class {
    //Protocol to pass grade change
    func changeGrade(_ id: Int?)
}
