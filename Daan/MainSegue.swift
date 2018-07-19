//
//  MainSegue.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/10.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class MainSegue: UIStoryboardSegue {
    override func perform() {
        print("MainSegue Performing")
        self.source.present(self.destination as UIViewController,
                                          animated: true,
                                          completion: nil)
    }
}
