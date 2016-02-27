//
//  HCGBiPadAppsViewController.swift
//  grabcatalog
//
//  Created by Isabel Yepes on 27/02/16.
//  Copyright © 2016 Hacemos Contactos. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HCGBiPadAppsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var appsCollectionView: UICollectionView!
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    let requestURL : String = "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json"
    
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! HCGBiPadAppsCollectionViewCell
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
