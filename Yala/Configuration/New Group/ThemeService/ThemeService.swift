//
//  ThemeService.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

/**
    This protocol defines static functions for aplication theme for Colors and Fonts being used at places. Application should implement this protocol to provide their values.
 */

protocol ThemeService {
    
    // MARK: color methods
    
    static func themeColor() -> UIColor
    
    static func whiteColor() -> UIColor
    
    static func blueColor() -> UIColor
    
    static func darkGrayColor() -> UIColor
    
    static func spinnerWhiteBackgroundColor() -> UIColor
    
    static func navBarGradientStop1Color() -> UIColor
    
    static func navBarGradientStop2Color() -> UIColor
    
    static func sourceSansProBoldFont(ofSize size: CGFloat) -> UIFont?
    static func openSansSemiBoldFont(ofSize size: CGFloat) -> UIFont?
    
    // MARK: gradient methods
    
    static func gradientLayerForHorizontalBounds(bounds: CGRect) -> CAGradientLayer
    static func gradientLayerForVerticleBounds(bounds: CGRect) -> CAGradientLayer
    static func imageLayerForGradientBackground(bounds: CGRect) -> UIImage
    static func imageLayerForGradientBackgroundBlue(bounds: CGRect) -> UIImage
}
