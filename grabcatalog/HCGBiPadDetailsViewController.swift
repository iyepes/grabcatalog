//
//  HCGBiPadDetailsViewController.swift
//  grabcatalog
//
//  Created by Isabel Yepes on 27/02/16.
//  Copyright © 2016 Hacemos Contactos. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class HCGBiPadDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UITextView!
    
    @IBOutlet weak var appImage: UIImageView!
    
    var generalParam : HCGBGeneralParams = HCGBGeneralParams()
    
    var currentColor : UIColor = UIColor.lightGrayColor()
    
    var currentItem: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.currentColor
        if let _ = self.currentItem.valueForKey("appName") {
            nameLabel.text = self.currentItem.valueForKey("appName") as? String
            titleLabel.text = self.currentItem.valueForKey("appTitle") as? String
            let imageURL = self.currentItem.valueForKey("appImage") as? String
            let URL = NSURL(string: imageURL!)!
            appImage.af_setImageWithURL(URL)
            summaryLabel.text = self.currentItem.valueForKey("appSummary") as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
