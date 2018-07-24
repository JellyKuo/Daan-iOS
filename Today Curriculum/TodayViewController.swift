//
//  TodayViewController.swift
//  Today Curriculum
//
//  Created by 郭東岳 on 2017/12/20.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import NotificationCenter
import ObjectMapper

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var stackView: UIStackView!
    var curriculum:CurriculumWeek? = nil
    var h = 20.0
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // Fallback on earlier versions
            //TODO: Earlier version?
        }
        
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else {
            fatalError("Cannot init UserDefaults with suiteName group.com.Jelly.Daan")
        }
        if let JSON = userDefaults.string(forKey: "curriculumJSON"), JSON != "" {
            let decoder = JSONDecoder()
            do{
                let curr = try decoder.decode(CurriculumWeek.self, from: JSON.data(using: .utf8)!)
                print("Got curriculum from UsersDefault, using that")
                if #available(iOSApplicationExtension 10.0, *) {
                    self.curriculum = curr
                    if(self.extensionContext?.widgetActiveDisplayMode == .expanded){
                        generateFullUI(currWeek: curr)
                    }
                    else{
                        generateCompactUI(currWeek: curr)
                    }
                } else {
                    generateFullUI(currWeek: curr)
                }
            }
            catch{
                print("JSON cannot be decoded to object, Grabbing from Api")
            }
            /*
            if let curr = CurriculumWeek(JSONString: JSON){
                print("Got curriculum JSON from UserDefaults and mapped to object")
                if #available(iOSApplicationExtension 10.0, *) {
                    self.curriculum = curr
                    if(self.extensionContext?.widgetActiveDisplayMode == .expanded){
                        generateFullUI(currWeek: curr)
                    }
                    else{
                        generateCompactUI(currWeek: curr)
                    }
                } else {
                    generateFullUI(currWeek: curr)
                }
 
            }
            else{
                print("Got curriculum JSON but cannot map it to object")
                PromptOpenApp()
                completionHandler(NCUpdateResult.noData)
                return
            }
            */
        }
        else {
            print("Got userDefaults but JSON doesn't exist")
            PromptOpenApp()
            completionHandler(NCUpdateResult.noData)
            return
        }
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func getCurrDay(currWeek: CurriculumWeek) -> [Curriculum]{
        let date = Date()
        let weekday = Calendar.current.component(.weekday, from: date)
        let index:Int
        if weekday <= 6 && weekday >= 2 {
            let hour = Calendar.current.component(.hour, from: date)
            if hour < 16{
                index = weekday - 2
                descLabel.text = NSLocalizedString("TODAY", comment: "Today")
            }
            else{
                if weekday != 6{
                    index = weekday - 1
                    descLabel.text = NSLocalizedString("TOMORROW", comment: "Tomorrow")
                }
                else{
                    index = 0
                    descLabel.text = NSLocalizedString("MONDAY", comment: "Monday")
                }
            }
        }
        else{
            index = 0
        }
        
        let day:[Curriculum]?
        switch index {
        case 0:
            day = currWeek.week1
        case 1:
            day = currWeek.week2
        case 2:
            day = currWeek.week3
        case 3:
            day = currWeek.week4
        case 4:
            day = currWeek.week5
        default:
            fatalError("index for Monday to Friday is out of range! Date: \(date), Index: \(index)")
        }
        if day != nil{
            return day!
        }
        else{
            fatalError("The selected week curriculum is nil! Date: \(date), Index: \(index)")
        }
    }
    
    func getCurr(currWeek:CurriculumWeek) -> Curriculum {
        let date = Date()
        let weekday = Calendar.current.component(.weekday, from: date)
        let index:Int
        let today:Bool
        if weekday <= 6 && weekday >= 2 {
            let hour = Calendar.current.component(.hour, from: date)
            if hour < 16{
                let minute = Calendar.current.component(.minute, from: date)
                if hour == 15 && minute > 10{
                    today = false
                    if weekday != 6{
                        index = weekday - 1
                    }
                    else{
                        index = 0
                        descLabel.text = NSLocalizedString("MONDAY", comment: "Monday")
                        return currWeek.week1![0]
                    }
                }
                else{
                    index = weekday - 2
                    today = true
                }
            }
            else{
                today = false
                if weekday != 6{
                    index = weekday - 1
                }
                else{
                    index = 0
                    descLabel.text = NSLocalizedString("MONDAY", comment: "Monday")
                    return currWeek.week1![0]
                }
            }
        }
        else{
            today = false
            index = 0
        }
        
        let res:[Curriculum]?
        switch index {
        case 0:
            res = currWeek.week1
        case 1:
            res = currWeek.week2
        case 2:
            res = currWeek.week3
        case 3:
            res = currWeek.week4
        case 4:
            res = currWeek.week5
        default:
            fatalError("index for Monday to Friday is out of range! Date: \(date), Index: \(index)")
        }
        if let day = res{
            if today{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd "
                let dateStr = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                
                for cls in day{
                    let clsTime = dateFormatter.date(from: dateStr + cls.start!)!
                    if date < clsTime{
                        descLabel.text = NSLocalizedString("NEXT_CLASS", comment: "Next class in curriculum")
                        return cls
                    }
                }
                fatalError()
                
            }
            else{
                descLabel.text = NSLocalizedString("TOMORROW", comment: "Tomorrow")
                return day[0]
            }
        }
        else{
            fatalError("result is NIL")
        }
    }
    
    func generateFullUI(currWeek:CurriculumWeek){
        let day = getCurrDay(currWeek: currWeek)
        for subview in stackView.subviews{
            subview.removeFromSuperview()
        }
        h = 15.0 + Double(descLabel.frame.size.height)
        for cls in day{
            let newEntry = createEntry(cls: cls)
            //newEntry.isHidden = true
            newEntry.sizeToFit()
            stackView.addArrangedSubview(newEntry)
            h += Double(newEntry.frame.size.height) + 10
        }
        stackView.sizeToFit()
    }
    
    func generateCompactUI(currWeek: CurriculumWeek){
        for subview in stackView.subviews{
            subview.removeFromSuperview()
        }
        let cls = getCurr(currWeek: currWeek)
        stackView.addArrangedSubview(createEntry(cls: cls))
    }
    
    func createEntry(cls:Curriculum) -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor(hex: "fa9d29")
        label.text = " " + cls.start! + "  " + cls.subject!
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 2.5
        label.layer.borderColor = label.backgroundColor!.cgColor
        return label
    }
    
    func PromptOpenApp() {
        for subview in stackView.subviews{
            subview.removeFromSuperview()
        }
        descLabel.isHidden = true
        let label = UILabel()
        label.backgroundColor = UIColor(hex: "fa9d29")
        label.text = " " + NSLocalizedString("OPEN_APP_PROMPT", comment: "Prompts to open app")
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 2.5
        label.layer.borderColor = label.backgroundColor!.cgColor
        stackView.addArrangedSubview(label)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if curriculum != nil{
            if activeDisplayMode == .expanded {
                generateFullUI(currWeek: curriculum!)
                preferredContentSize = CGSize(width: 0.0, height: h)
            }
            else if activeDisplayMode == .compact {
                generateCompactUI(currWeek: curriculum!)
                preferredContentSize = maxSize
            }
        }
    }
}
