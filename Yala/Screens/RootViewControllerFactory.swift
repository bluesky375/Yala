

//
//  TWGRootViewControllerFactory.swift
//  TWGiOS
//
//  Created by Ankita Porwal on 28/11/16.
//  Copyright © 2016 Yala. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class RootViewControllerFactory: NSObject {
    
    static let shared = RootViewControllerFactory()
    var slideMenuViewController: SideMenuWrapper?
    
    enum RootViewControllerType {
        case home(Int), signup, signin, landing, onboarding
    }
    
    func configureRootViewController(forType type:RootViewControllerType, window: UIWindow, animated: Bool) {
        switch type {
        case .landing:
            let vc = LandingViewController.fromStoryboard()
            let navigationController = UINavigationController.init(rootViewController: vc)
            setRootViewController(navigationController, toWindow: window, animated: animated)
            break
        case .signup:
            let vc = RegistrationViewController.fromStoryboard()
            let navigationController = UINavigationController.init(rootViewController: vc)
            setRootViewController(navigationController, toWindow: window, animated: animated)
            break
        case .signin:
             let loginVC = LoginViewController.fromStoryboard()
             let navigationController = UINavigationController.init(rootViewController: loginVC)
             setRootViewController(navigationController, toWindow: window, animated: animated)
            break
        case .onboarding:
            let vc = OnboardingViewController.fromStoryboard()
            let navigationController = UINavigationController.init(rootViewController: vc)
            navigationController.navigationBar.isHidden = true
            setRootViewController(navigationController, toWindow: window, animated: animated)
            break
        case .home(let selectedTab):
            
            
            let homeVC = HomeSegmentViewController.fromStoryboard()
            
            let navigationController2 = UINavigationController.init(rootViewController: homeVC)
            homeVC.selectedTabIndex = selectedTab
            
            let sideMenuVC = SideMenuViewController.fromStoryboard()
            let navigationController1 = UINavigationController.init(rootViewController: sideMenuVC)
            
            slideMenuViewController = SideMenuWrapper(mainViewController: navigationController2, leftMenuViewController: navigationController1)
            self.setRootViewController(slideMenuViewController!, toWindow: window, animated: animated)
            break
        }
    }
    
    func setRootViewController(_ viewController: UIViewController, toWindow window:UIWindow, animated: Bool) {
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                 window.rootViewController = viewController
                window.makeKeyAndVisible()
            }, completion: nil)
        } else {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
}


