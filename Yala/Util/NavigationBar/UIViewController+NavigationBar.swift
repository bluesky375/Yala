//
//  UIViewController+NavigationBar.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import UIKit

/**
    This extension on UINavigationController used to set different navigation bar like white, blue or gradient.
    Change color from theme class for respective colors and customise navigation bar
 */
extension UINavigationController {
    
    enum NavigationBarType {
        case gradient, blue, white
    }
    
    func setNavigationBarAppearance(toType type: NavigationBarType) {
        switch type {
        case .gradient:
            /*
             navigationBar.setBackgroundImage(UIImage(named: "hom_screen_bg_image")!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
             */navigationBar.setBackgroundImage(AppContentProvider.theme.imageLayerForGradientBackground(bounds: (navigationBar.bounds)), for: .default)
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: AppContentProvider.theme.whiteColor(), NSAttributedStringKey.font: YalaThemeService.openSansSemiBoldFont(ofSize: 15)]
        case .blue:
            navigationBar.setBackgroundImage(AppContentProvider.theme.imageLayerForGradientBackgroundBlue(bounds: (navigationBar.bounds)), for: .default)
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: AppContentProvider.theme.whiteColor(), NSAttributedStringKey.font: YalaThemeService.openSansSemiBoldFont(ofSize: 15)]
        case .white:
            navigationBar.barTintColor = AppContentProvider.theme.whiteColor()
            navigationBar.tintColor = AppContentProvider.theme.themeColor()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: AppContentProvider.theme.themeColor(), NSAttributedStringKey.font: YalaThemeService.openSansSemiBoldFont(ofSize: 15)]
        }
    }
    
}
