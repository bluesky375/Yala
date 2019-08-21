//
//  CustomNavigationController.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

/**
    This class can be used to create custom navigation controller with light & black status bars
*/

class CustomNavigationController: UINavigationController {
    
    var lightStatusBar: Bool = false {
        didSet {
            if lightStatusBar {
                navigationBar.barStyle = .black
            } else {
                navigationBar.barStyle = .default
            }
        }
    }
}
