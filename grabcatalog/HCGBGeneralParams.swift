//
//  HCGBGeneralParams.swift
//  grabcatalog
//
//  Created by Isabel Yepes on 27/02/16.
//  Copyright © 2016 Hacemos Contactos. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

var userDefaults = NSUserDefaults.standardUserDefaults()

extension UIColor {
    convenience init(hexString:String, alpha:CGFloat) {
        let hexString:NSString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let scanner            = NSScanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
}

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context,CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class HCGBGeneralParams: NSObject {

    //App appereance
    let appColor:UIColor = UIColor(hexString: "177EB7",alpha: 1.0)
    let selectedColor:UIColor = UIColor(hexString: "07283B",alpha: 1.0)
    let textColor:UIColor = UIColor(hexString: "FFFFFF",alpha: 1.0)
    let backgroundColor:UIColor = UIColor(hexString: "07283B",alpha: 1.0)
    let unselectedColor:UIColor = UIColor.lightGrayColor() //AAAAAA
    
    //Data
    var appData : NSDictionary {
        if let dataDictionary =  userDefaults.dictionaryForKey("dataDictionary") {
            return dataDictionary
        } else {
            let bundle = NSBundle.mainBundle()
            let path = bundle.pathForResource("data", ofType: "json")
            let data : NSData = NSData(contentsOfFile: path!)!
            do {
                let JSONVar = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue: 0))
                guard let JSONDictionary :NSDictionary = JSONVar as? NSDictionary else {
                    print("Not a Dictionary")
                    // put in function
                    return [:]
                }
                let json = JSON(data: data)
                let entries = json["feed","entry"].array
                var downloadedData : NSMutableDictionary = [:]
                for (item) in entries! {
                    let categoryName = item["category","attributes","label"].string
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
                userDefaults.setValue(downloadedData, forKey: "dataDictionary")
                return downloadedData
            }
            catch let JSONError as NSError {
                print("\(JSONError)")
                return [:]
            }
        }
    }
    
}
