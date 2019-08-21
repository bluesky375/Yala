//
//  UIView+Gradient.swift
//  Yala
//
//  Created by Ankita on 07/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import UIKit

class RoundedView: UIView {
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}

class BorderedView: UIView {
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 10
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
    }
}

extension UIView {
    
    func applyVerticalGradient(colors: [UIColor]) -> Void {
        self.applyVerticalGradient(colors: colors, locations: nil)
    }
    
    func applyHorizontalGradient(colors: [UIColor]) -> Void {
        self.applyHorizontalGradient(colors: colors, locations: nil)
    }
    
    func applyVerticalGradient(colors: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyHorizontalGradient(colors: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x:0.0, y:0.0)
        gradient.endPoint = CGPoint(x:1.0, y:0.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
