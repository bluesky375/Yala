//
//  SideMenuWrapper.swift
//  TWGiOS
//
//  Created by Arpit Pittie on 3/24/17.
//  Copyright © 2017 Coverati. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SideMenuWrapper: SlideMenuController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuView()
    }
    
    func setupMenuView() {
        SlideMenuOptions.animationDuration = 0.3
        SlideMenuOptions.animationOptions = [.transitionFlipFromTop]
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.leftViewWidth = 300
        SlideMenuOptions.panGesturesEnabled = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
