//
//  GradientBackground.swift
//  Yala
//
//  Created by Ankita on 30/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradientBackgroundTheme() {
        let gradientLayer = YalaThemeService.gradientLayerForHorizontalBounds(bounds: self.bounds)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}
