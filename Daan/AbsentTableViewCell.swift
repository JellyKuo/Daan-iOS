//
//  AbsentTableViewCell.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/14.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class AbsentTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var classLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
