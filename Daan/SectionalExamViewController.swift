//
//  SectionalExamViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/15.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class SectionalExamViewController: UIViewController {
    
    var token:Token? = nil
    var semester:Int = 1
    
    //TODO: Use tableviewheader
    //Controls semester change delegate
    weak var delegate:SectionalExamViewControllerDelegate?
    
    @IBOutlet weak var semesterLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        semesterLab.text = NSLocalizedString("UP_SEMESTER", comment:"1st semester text")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChangeSemesterTap(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if(semester>1){
                semester -= 1
                semesterLab.text = NSLocalizedString("UP_SEMESTER", comment:"1st semester text")
            }
            else {return}
        case 2:
            if(semester<2){
                semester += 1
                semesterLab.text = NSLocalizedString("DOWN_SEMESTER", comment:"2nd semester text")
            }
            else {return}
        default:
            fatalError("The tapped button's id is neither 1 nor 2!")
        }
        
        delegate?.changeSemester(self.semester)
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
        if segue.identifier == "SectionalContainerSegue" {
            print("Preparing SectionalContainerSegue")
            let destVC = segue.destination as! SectionalExamTableViewController
            destVC.token = self.token
            //TODO: Use tableviewheader
            //Set the delegate to SectionalExamTableViewController
            self.delegate = destVC
        }
    }
}

//TODO: Use tableviewheader
protocol SectionalExamViewControllerDelegate: class {
    //Protocol to pass semester change
    func changeSemester(_ id: Int?)
}
