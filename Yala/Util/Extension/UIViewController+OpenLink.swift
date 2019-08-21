//
//  UIViewController+OpenLink.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

/**
    This extension provides helper methods for opening a URL or a string in safari. This will take user out of the application and open the provided link in safari
 */

extension UIViewController {
    
    func open(link: String) {
        let urlString = link.contains("http") ? link : "http://\(link)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func open(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
