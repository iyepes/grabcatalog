//
//  HCGBiPhoneCategoriesViewController.swift
//  grabcatalog
//
//  Created by Isabel Yepes on 27/02/16.
//  Copyright © 2016 Hacemos Contactos. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HCGBiPhoneCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var categoriesTableView: UITableView!
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    var appData : NSDictionary = [:]
    
    var generalParam : HCGBGeneralParams = HCGBGeneralParams()
    
    var currentItem: NSDictionary = [:]
    
    var currentColor : UIColor = UIColor.lightGrayColor()
    
    var requestURL : String = ""
    
    //Cell reusable ID
    let cellId = "CategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestURL = generalParam.requestURL
        // Do any additional setup after loading the view.
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        loadingActivityIndicator.startAnimating()
        refresh(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Data source update
    
    /// Performs the full query then updates the UI
    func refresh (sender: AnyObject!) {
        
        Alamofire.request(.GET, self.requestURL)
            .responseJSON { response in
                //debugPrint(response)
                if let data : NSData = response.data {
                    do {
                        let JSONVar = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue: 0))
                        guard let JSONDictionary :NSDictionary = JSONVar as? NSDictionary else {
                            print("Not a Dictionary")
                            self.appData = self.generalParam.appData
                            return
                        }
                        let json = JSON(data: data)
                        let entries = json["feed","entry"].array
                        var downloadedData : NSMutableDictionary = [:]
                        var numberOfCategories = 0
                        for (item) in entries! {
                            let categoryName = item["category","attributes","label"].string
                            //print(categoryName)
                            let jsonAppData : NSDictionary =
                            ["appId":item["id","attributes","im:id"].string!,
                                "appName":item["im:name","label"].string!,
                                "appImage":item["im:image",2,"label"].string!,
                                "appTitle":item["title","label"].string!,
                                "appSummary":item["summary","label"].string!]
                            if let categoryCount = downloadedData.valueForKey("\(categoryName!)"+"Count") as? NSNumber {
                                let newValue = categoryCount.integerValue + 1
                                downloadedData.setValue(newValue, forKey: "\(categoryName!)"+"Count")
                                var categoriesData = downloadedData.valueForKey("\(categoryName!)") as! NSMutableDictionary
                                categoriesData.setValue(jsonAppData, forKey: "\(newValue)")
                                downloadedData.setValue(categoriesData, forKey: "\(categoryName!)")
                            } else {
                                downloadedData.setValue(1, forKey: "\(categoryName!)"+"Count")
                                numberOfCategories = numberOfCategories + 1
                                let categoriesData : NSMutableDictionary = [:]
                                categoriesData.setValue(jsonAppData, forKey: "1")
                                downloadedData.setValue(categoriesData, forKey: categoryName!)
                                if let namesList = downloadedData.valueForKey("namesList")
                                {
                                    var categoriesDictionary = downloadedData.valueForKey("namesList") as! NSMutableDictionary
                                    categoriesDictionary.setValue(categoryName!, forKey: String(numberOfCategories))
                                    downloadedData.setValue(categoriesDictionary, forKey: "namesList")
                                } else {
                                    let categoriesDictionary : NSMutableDictionary = [:]
                                    categoriesDictionary.setValue(categoryName!, forKey: String(numberOfCategories))
                                    downloadedData.setValue(categoriesDictionary, forKey: "namesList")
                                }
                            }
                        }
                        self.userDefaults.setValue(downloadedData, forKey: "dataDictionary")
                        self.appData = downloadedData
                        self.loadingActivityIndicator.stopAnimating()
                        self.categoriesTableView.reloadData()
                    }
                    catch let JSONError as NSError {
                        print("\(JSONError)")
                        self.appData = self.generalParam.appData
                    }
                } else {
                    self.appData = self.generalParam.appData
                }
        }
    }
    
    // MARK: - Table View Delegate Protocol
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let namesList = self.appData.valueForKey("namesList") {
            let resultsDictionary = namesList as! NSDictionary
            return resultsDictionary.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! HCGBiPhoneCategoryTableViewCell!
        cell.nameLabel.text = "Category"
        if let namesList = self.appData.valueForKey("namesList") {
            let resultsDictionary = namesList as! NSDictionary
            //print("\(indexPath.row+1)")
            cell.nameLabel.text = resultsDictionary.valueForKey("\(indexPath.row+1)") as? String
            cell.backgroundColor = self.generalParam.getPalleteColor("\(indexPath.row+1)")
            cell.tag = indexPath.row+1
            return cell
        } else {
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let namesList = self.appData.valueForKey("namesList") {
            let resultsDictionary = namesList as! NSDictionary
            //print("\(indexPath.row+1)")
            let categoryName = resultsDictionary.valueForKey("\(indexPath.row+1)") as? String
            let categoriesData = self.appData.valueForKey(categoryName!) as! NSDictionary
            self.currentItem = categoriesData
            self.currentColor = self.generalParam.getPalleteColor("\(indexPath.row+1)")
            performSegueWithIdentifier("OpenAppsView", sender: self)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "OpenAppsView") {
            var destinationViewController = segue.destinationViewController as! HCGBiPhoneAppsViewController
            destinationViewController.currentItem = currentItem
            destinationViewController.currentColor = currentColor
            
        }
    }
    

}
