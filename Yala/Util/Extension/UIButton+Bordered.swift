//
//  UIButton+Bordered.swift
//  Yala
//
//  Created by Ankita on 07/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import UIKit

class YalaBorderdView: UIButton {
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        layer.cornerRadius = frame.size.height/2
        clipsToBounds = true
    }
}

class YalaCorneredView: UIView {
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 15
        clipsToBounds = true
    }
}

@IBDesignable class YalaBorderdButtonNonFilled: UIButton {
    
    @IBInspectable var borderColor: UIColor = UIColor.darkGray
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        layer.cornerRadius = frame.size.height/2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 2
        clipsToBounds = true
    }
}

@IBDesignable class YalaSelectionButton: UIButton {
    
    @IBInspectable var selectedBgColor: UIColor = UIColor.darkGray
    @IBInspectable var deselectBorderColor: UIColor = UIColor.darkGray
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        layer.cornerRadius = frame.size.height/2
        setButtonState(true)
        clipsToBounds = true
        
        backgroundColor = selectedBgColor
    }
    
    func setButtonState(_ isSelected: Bool) {
        if isSelected {
            backgroundColor = selectedBgColor
            layer.borderColor = UIColor.clear.cgColor
            titleLabel?.textColor = UIColor.white
        } else {
            backgroundColor = UIColor.white
            layer.borderColor = deselectBorderColor.cgColor
            layer.borderWidth = 2
            titleLabel?.textColor = deselectBorderColor
        }
    }
}
