//
//  CurriculumPageViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/18.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import ObjectMapper

class CurriculumPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var token:Token? = nil
    var curriculumWeek:CurriculumWeek? = nil
    var tableVCs:[CurriculumTableViewController]? = nil
    var activityInd:UIActivityIndicatorView!
    
    @IBOutlet weak var weekNavItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        activityInd = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityInd.color = UIColor.gray
        let barButton = UIBarButtonItem(customView: activityInd)
        navigationItem.rightBarButtonItem = barButton
        activityInd.startAnimating()
        
        GetData()
        
        self.delegate = self
        self.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func GetData() {
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
            fatalError("Cannot init new UserDefaults with suiteName")
        }
        if let JSON = userDefaults.string(forKey: "curriculumJSON"){
            if JSON != "" , let modelObject = CurriculumWeek(JSONString: JSON){
                print("Got curriculum from UsersDefault, using that")
                curriculumWeek = modelObject
                createPage()
            }
            else{
                print("Got JSON from UsersDefault, but was unable to map it to object. Grabbing from Api")
                ApiReq()
            }
        }
        else{
            print("No data stored in UsersDefaults with key curriculumJSON. Grabbing from Api")
            ApiReq()
        }
    }
    
    func ApiReq() {
        let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan")
        let req = ApiRequest(path: "curriculum", method: .get, token: self.token)
        req.request {(res,apierr,alaerr) in
            if let result = res {
                self.curriculumWeek = CurriculumWeek(JSON: result)
                if let JSONStr = self.curriculumWeek?.toJSONString(){
                    print("Got curriculum from Api, setting userDefaults for key curriculumJSON")
                    userDefaults?.set(JSONStr, forKey: "curriculumJSON")
                }
                else{
                    print("Got curriculum from Api, but was unable to get JSON string from object, skip saving")
                }
                self.createPage()
            }
            else if let apiError = apierr{
                let alert = UIAlertController(title: NSLocalizedString("API_ERROR_TITLE", comment:"API Error message on title"), message: apiError.error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                    print("Api Error alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else if let alamoError = alaerr{
                let alert = UIAlertController(title: NSLocalizedString("CONN_ERROR_TITLE", comment:"Connection Error message on title"), message: alamoError.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_ACT", comment:"Ok action on tap"), style: .`default`, handler: { _ in
                    print("Alamofire Error alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func createPage(){
        guard let data = curriculumWeek else{
            fatalError("createPage called but CurriculumWeek is nil")
        }
        tableVCs = []
        let w1VC = storyboard?.instantiateViewController(withIdentifier: "CurriculumTableView") as! CurriculumTableViewController
        let w2VC = storyboard?.instantiateViewController(withIdentifier: "CurriculumTableView") as! CurriculumTableViewController
        let w3VC = storyboard?.instantiateViewController(withIdentifier: "CurriculumTableView") as! CurriculumTableViewController
        let w4VC = storyboard?.instantiateViewController(withIdentifier: "CurriculumTableView") as! CurriculumTableViewController
        let w5VC = storyboard?.instantiateViewController(withIdentifier: "CurriculumTableView") as! CurriculumTableViewController
        w1VC.curriculums = data.week1
        w2VC.curriculums = data.week2
        w3VC.curriculums = data.week3
        w4VC.curriculums = data.week4
        w5VC.curriculums = data.week5
        tableVCs?.append(w1VC)
        tableVCs?.append(w2VC)
        tableVCs?.append(w3VC)
        tableVCs?.append(w4VC)
        tableVCs?.append(w5VC)
        
        let date = Date()
        let weekday = Calendar.current.component(.weekday, from: date)
        let index:Int
        if weekday <= 6 && weekday >= 2{
            let hour = Calendar.current.component(.hour, from: date)
            if hour < 16{
                index = weekday - 2
            }
            else{
                if weekday != 6{
                    index = weekday - 1
                }
                else{
                    index = 0
                }
            }
        }
        else{
            index = 0
        }
        SetNavTitle(week: index)
        setViewControllers([tableVCs![index]], direction: .forward, animated: false, completion: nil)
        
        activityInd.stopAnimating()
    }
    
    func SetNavTitle(week:Int){
        let weekdayStr:String
        switch week {
        case 0:
            weekdayStr = NSLocalizedString("MONDAY", comment: "Monday")
        case 1:
            weekdayStr = NSLocalizedString("TUESDAY", comment: "Tuesday")
        case 2:
            weekdayStr = NSLocalizedString("WEDNESDAY", comment: "Wednesday")
        case 3:
            weekdayStr = NSLocalizedString("THRUSDAY", comment: "Thursday")
        case 4:
            weekdayStr = NSLocalizedString("FRIDAY", comment: "Friday")
        default:
            print("Got \(week) as week number in CurriculumTableViewController, which doesn't match 0~5")
            weekdayStr = String(week)
        }
        
        weekNavItem.title = weekdayStr
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = tableVCs!.index(of: viewController as! CurriculumTableViewController) else {
            return nil
        }
        let previousIndex = index - 1
        guard previousIndex >= 0 && previousIndex < tableVCs!.count else {
            return nil
        }
        return tableVCs![previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = tableVCs!.index(of: viewController as! CurriculumTableViewController) else {
            return nil
        }
        let nextIndex = index + 1
        guard nextIndex >= 0 && nextIndex < tableVCs!.count else {
            return nil
        }
        return tableVCs![nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if !completed{
            return
        }
        if let currentTableViewController = pageViewController.viewControllers![0] as? CurriculumTableViewController{
            let index = tableVCs?.index(of: currentTableViewController)
            SetNavTitle(week: index!)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
