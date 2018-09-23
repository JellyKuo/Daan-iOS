//
//  NextClassIntentHandler.swift
//  Curriculum Intent
//
//  Created by 郭東岳 on 2018/9/20.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import Foundation

class NextClassIntentHandler: NSObject, NextClassIntentHandling{
    
    var curriculum:CurriculumWeek? = nil
    
    func handle(intent: NextClassIntent, completion: @escaping (NextClassIntentResponse) -> Void) {
        
        // FIXME: Framework!!!
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else {
            fatalError("Cannot init UserDefaults with suiteName group.com.Jelly.Daan")
        }
        if let JSON = userDefaults.string(forKey: "curriculumJSON"), JSON != "" {
            let decoder = JSONDecoder()
            do{
                let curr = try decoder.decode(CurriculumWeek.self, from: JSON.data(using: .utf8)!)
                print("Got curriculum from UsersDefault, using that")
                let cls = getCurr(currWeek: curr)
                completion(NextClassIntentResponse.success(nextClass: cls.subject ?? "nil"))
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
            completion(NextClassIntentResponse(code: .failureNoData, userActivity: nil))
            return
        }
        completion(NextClassIntentResponse(code: .failure, userActivity: nil))
        
        
        
    }
    
    func confirm(intent: NextClassIntent, completion: @escaping (NextClassIntentResponse) -> Void) {
        completion(NextClassIntentResponse(code: .ready, userActivity: nil))
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
                        return currWeek.week1[0]
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
                    return currWeek.week1[0]
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
                        return cls
                    }
                }
                fatalError()
                
            }
            else{
                return day[0]
            }
        }
        else{
            fatalError("result is NIL")
        }
    }
}
