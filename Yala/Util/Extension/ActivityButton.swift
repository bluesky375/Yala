//
//  ActivityButton.swift
//  Yala
//
//  Created by Ankita on 15/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import UIKit
import EMSpinnerButton

class ActivityButton: EMSpinnerButton {
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        let color1 = UIColor.init(rgb: 0x218fd8)
        let color2 = UIColor.init(rgb: 0x31abec)
        
        titleColor = UIColor.white
        backgroundColor = UIColor.init(rgb: 0x218fd8)
        gradientColors = [color1.cgColor, color2.cgColor]
        cornerRadius = frame.height/2
    }
}
