//
//  HCGBiPhoneAppsViewController.swift
//  grabcatalog
//
//  Created by Isabel Yepes on 29/02/16.
//  Copyright © 2016 Hacemos Contactos. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class HCGBiPhoneAppsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var appsTableView: UITableView!
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var generalParam : HCGBGeneralParams = HCGBGeneralParams()
    
    var currentColor : UIColor = UIColor.lightGrayColor()
    
    var currentItem: NSDictionary = [:]
    
    var currentApp: NSDictionary = [:]
    
    //Cell reusable ID
    let cellId = "AppCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appsTableView.delegate = self
        appsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Delegate Protocol
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.currentItem.valueForKey("1") {
            self.loadingActivityIndicator.stopAnimating()
            return self.currentItem.count
        } else {
            return 20
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! HCGBiPhoneAppsTableViewCell!
        if let _ = self.currentItem.valueForKey("\(indexPath.row+1)") {
            self.currentApp = self.currentItem.valueForKey("\(indexPath.row+1)") as! NSDictionary
            cell.nameLabel.text = self.currentApp.valueForKey("appName") as? String
            let imageURL = self.currentApp.valueForKey("appImage") as? String
            let URL = NSURL(string: imageURL!)!
            cell.appImageView.af_setImageWithURL(URL)
        } else {
            cell.nameLabel.text = "App"
        }
        cell.backgroundColor = currentColor
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.currentItem.valueForKey("\(indexPath.row+1)") {
            self.currentApp = self.currentItem.valueForKey("\(indexPath.row+1)") as! NSDictionary
            performSegueWithIdentifier("OpenDetailsView", sender: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "OpenDetailsView") {
            var destinationViewController = segue.destinationViewController as! HCGBiPhoneDetailsViewController
            destinationViewController.currentItem = currentApp
            destinationViewController.currentColor = currentColor
            
        }
    }
    

}
