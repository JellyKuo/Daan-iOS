//
//  AttitudeTableViewCell.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/13.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class AttitudeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var descLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
