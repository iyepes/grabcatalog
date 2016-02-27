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
    
    let requestURL : String = "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json"
    
    //Cell reusable ID
    let cellId = "CategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json)")
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    // MARK: - Table View Delegate Protocol
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*if !collapsedStatus[section] {
        return listItems.items[section].count
        } else {
        return 0
        }
        */
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! HCGBiPhoneCategoryTableViewCell!
        /*
        let cellData = HCMFDataInfo(item: listItems.items[indexPath.section][indexPath.row]) as HCMFDataInfo
        cell.backgroundColor = self.currentParams.appColor
        cell.cartAddress.text = cellData.street
        */
        return cell
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
