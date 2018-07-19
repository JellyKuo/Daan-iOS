//
//  HistoryScoreTableViewCell.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/17.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class HistoryScoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var creditLab: UILabel!
    @IBOutlet weak var typeLab: UILabel!
    @IBOutlet weak var subjectLab: UILabel!
    @IBOutlet weak var upLab: UILabel!
    @IBOutlet weak var downLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
