//
//  UiviewExtensions.swift
//  Yala
//
//  Created by Admin on 4/3/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
