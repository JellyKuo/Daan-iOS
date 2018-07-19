//
//  CurriculumTableViewCell.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/19.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class CurriculumTableViewCell: UITableViewCell {
    @IBOutlet weak var startLab: UILabel!
    @IBOutlet weak var endLab: UILabel!
    @IBOutlet weak var subjectLab: UILabel!
    @IBOutlet weak var teacherLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
