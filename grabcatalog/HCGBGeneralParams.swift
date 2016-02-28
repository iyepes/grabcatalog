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
    
    let palette : NSDictionary =
           ["1":"E8D59E",
            "2":"9EE8B0",
            "3":"9EB1E8",
            "4":"E89ED6",
            "5":"B8ABEB",
            "6":"EBABBE",
            "7":"DEEBAB",
            "8":"ABEBD8",
            "9":"E8ED55",
           "10":"5A55ED",
           "11":"ED559C",
           "12":"55EDA6",
           "13":"46DE28",
           "14":"C028DE",
           "15":"28A1DE",
           "16":"DE6528",
           "17":"E3B0E8",
           "18":"E8C7B0",
           "19":"B5E8B0",
           "20":"B0D1E8"]
    
    
    func getPalleteColor(colorIndex : String) -> UIColor {
        if let hexColor : String = palette.valueForKey(colorIndex) as? String {
            return UIColor(hexString: hexColor,alpha: 1.0)
        } else {
            return unselectedColor
        }
    }
    
    //Data
    var appData : NSDictionary {
        if let dataDictionary =  userDefaults.dictionaryForKey("dataDictionary") {
            let resultsDictionary = dataDictionary as NSDictionary
            return resultsDictionary
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
