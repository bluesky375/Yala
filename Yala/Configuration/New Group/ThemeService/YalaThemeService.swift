//
//  NMIThemeService.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

/**
    This struct implements all theme functions mentioned in ThemeService
 */

struct YalaThemeService: ThemeService {
    
    // MARK: color methods
    
    static func themeColor() -> UIColor {
        return #colorLiteral(red: 0.2862745098, green: 0.6078431373, blue: 0.7921568627, alpha: 1)
    }
    
    static func whiteColor() -> UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static func blueColor() -> UIColor {
        return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    }
    
    static func darkGrayColor() -> UIColor {
        return #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
    }
    
    static func spinnerWhiteBackgroundColor() -> UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.33)
    }
    
    static func navBarGradientStop1Color() -> UIColor {
        return #colorLiteral(red: 0.09803921569, green: 0.5411764706, blue: 0.8549019608, alpha: 1)
    }
    
    static func navBarGradientStop2Color() -> UIColor {
        return #colorLiteral(red: 0.3058823529, green: 0.6666666667, blue: 0.8117647059, alpha: 1)
    }
    
    static func navBarGradientStop1BlueColor() -> UIColor {
        return #colorLiteral(red: 0.09803921569, green: 0.5411764706, blue: 0.8549019608, alpha: 1)
    }
    
    static func navBarGradientStop2BlueColor() -> UIColor {
        return #colorLiteral(red: 0.1411764706, green: 0.5647058824, blue: 0.8470588235, alpha: 1)
    }
    
    // MARK: Font methods
    
    static func sourceSansProBoldFont(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "OpenSans-Semibold", size: size)
    }
    
    static func openSansSemiBoldFont(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "OpenSans-Semibold", size: size)
    }
    
    static func openSansRegularFont(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "OpenSans", size: size)
    }
     
    // MARK: Gradient methods
    
    static func gradientLayerForHorizontalBounds(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [YalaThemeService.navBarGradientStop1Color().cgColor , YalaThemeService.navBarGradientStop2Color().cgColor ]
        layer.startPoint = CGPoint(x:0.0, y:0.0)
        layer.endPoint = CGPoint(x:1.0, y:0.0)
        return layer
    }
    
    static func gradientLayerForHorizontalBoundsBlue(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [YalaThemeService.navBarGradientStop1BlueColor().cgColor , YalaThemeService.navBarGradientStop2BlueColor().cgColor ]
        layer.startPoint = CGPoint(x:0.0, y:0.0)
        layer.endPoint = CGPoint(x:1.0, y:0.0)
        return layer
    }
    
    static func gradientLayerForVerticleBounds(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [YalaThemeService.navBarGradientStop1Color().cgColor , YalaThemeService.navBarGradientStop2Color().cgColor ]
        layer.startPoint = CGPoint(x:0.0, y:0.0)
        layer.endPoint = CGPoint(x:0.0, y:1.0)
        return layer
    }
    
    static func imageLayerForGradientBackground(bounds: CGRect) -> UIImage {
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let layer = YalaThemeService.gradientLayerForHorizontalBounds(bounds: updatedFrame)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func imageLayerForGradientBackgroundBlue(bounds: CGRect) -> UIImage {
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let layer = YalaThemeService.gradientLayerForHorizontalBoundsBlue(bounds: updatedFrame)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
