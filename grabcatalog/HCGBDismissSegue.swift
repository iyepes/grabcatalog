//
//  HCGBDismissSegue.swift
//  grabcatalog
//
//  Created by Isabel Yepes on 27/02/16.
//  Copyright © 2016 Hacemos Contactos. All rights reserved.
//

import Foundation
import UIKit

class HCGBDismissSegue: UIStoryboardSegue {

    override func perform() {
        var sourceViewController = self.sourceViewController as UIViewController
        sourceViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
