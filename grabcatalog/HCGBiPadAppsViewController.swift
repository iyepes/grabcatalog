//
//  HCGBiPadAppsViewController.swift
//  grabcatalog
//
//  Created by Isabel Yepes on 27/02/16.
//  Copyright © 2016 Hacemos Contactos. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class HCGBiPadAppsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var appsCollectionView: UICollectionView!
    
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
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        refresh(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Data source update
    
    /// Performs the full query then updates the UI
    func refresh (sender: AnyObject!) {

    }

    // MARK: - Table View Delegate Protocol
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! HCGBiPadAppsCollectionViewCell
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = self.currentItem.valueForKey("1") {
            self.loadingActivityIndicator.stopAnimating()
            return self.currentItem.count
        } else {
            return 20
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.currentItem.valueForKey("\(indexPath.row+1)") {
            self.currentApp = self.currentItem.valueForKey("\(indexPath.row+1)") as! NSDictionary
            performSegueWithIdentifier("OpenDetailsView", sender: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "OpenDetailsView") {
            var destinationViewController = segue.destinationViewController as! HCGBiPadDetailsViewController
            destinationViewController.currentItem = currentApp
            destinationViewController.currentColor = currentColor
            
        }
    }
    

}
