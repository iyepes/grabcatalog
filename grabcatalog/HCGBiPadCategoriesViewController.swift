//
//  HCGBiPadCategoriesViewController.swift
//  grabcatalog
//
//  Created by Isabel Yepes on 27/02/16.
//  Copyright © 2016 Hacemos Contactos. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HCGBiPadCategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    var appData : NSDictionary = [:]
    
    var generalParam : HCGBGeneralParams = HCGBGeneralParams()
    
    let requestURL : String = "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json"
    
    //Cell reusable ID
    let cellId = "CategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
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
                            var tempDictionary = downloadedData.valueForKey("\(categoryName!)") as! NSMutableDictionary
                            tempDictionary.setValue(jsonAppData, forKey: "\(newValue)")
                            downloadedData.setValue(tempDictionary, forKey: "\(categoryName!)")
                        } else {
                            downloadedData.setValue(1, forKey: "\(categoryName!)"+"Count")
                            let tempDictionary : NSMutableDictionary = [:]
                            tempDictionary.setValue(jsonAppData, forKey: "1")
                            downloadedData.setValue(tempDictionary, forKey: "\(categoryName!)")
                        }
                    }
                    self.userDefaults.setValue(downloadedData, forKey: "dataDictionary")
                    self.appData = downloadedData
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! HCGBiPadCategoryCollectionViewCell
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.nameLabel.text = "Hello"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
