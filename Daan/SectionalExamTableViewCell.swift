//
//  SectionalExamTableViewCell.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/15.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class SectionalExamTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectLab: UILabel!
    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var lab2: UILabel!
    @IBOutlet weak var lab3: UILabel!
    @IBOutlet weak var lab4: UILabel!
    @IBOutlet weak var lab5: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
