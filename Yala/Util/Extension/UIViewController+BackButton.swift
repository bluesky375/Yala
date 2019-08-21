//
//  UIViewController+TWGBackButton.swift
//  TWGiOS
//
//  Created by Ankita Porwal on 13/12/16.
//

import UIKit
import SlideMenuControllerSwift

extension UIViewController {
    
    func setLeftHamburgerButtonToShowMenu(withImage image: UIImage) {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.showMenuView))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func showMenuView() {
        slideMenuController()?.openLeft()
    }
    
    func setupBackButton(withAction action: Selector) {
        let backButton = backButtonItem(withAction: action)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.hidesBackButton = true
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-300, 0), for: .default)
    }
    
    private func backButtonItem(withAction action: Selector) -> UIBarButtonItem {
        let image = UIImage.init(named: "backButton")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem.init(image: image, style: .plain, target: self, action: action)
        backButton.accessibilityIdentifier = "backButton"
        return backButton
    }
    
    func setupBackButton() {
        let backButton = backButtonItem()
        let image = UIImage.init(named: "backButton")?.withRenderingMode(.alwaysOriginal)
        backButton.image = image
        backButton.accessibilityIdentifier = "backButton"
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.hidesBackButton = true
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-300, 0), for: .default)
    }
    
    func setupBackButtonWhite() {
        let backButton = backButtonItem()
        let image = UIImage.init(named: "backButton")?.withRenderingMode(.alwaysTemplate)
        backButton.image = image
        backButton.tintColor = UIColor.white
        backButton.accessibilityIdentifier = "backButton"
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.hidesBackButton = true
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-300, 0), for: .default)
    }
    
    func setupBackButtonWithPopToRootView() {
        let backButton = UIBarButtonItem.init(image: nil, style: .plain, target: self, action: #selector(UIViewController.popToRoot))
        let image = UIImage.init(named: "backButton")?.withRenderingMode(.alwaysOriginal)
        backButton.image = image
        backButton.accessibilityIdentifier = "backButton"
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.hidesBackButton = true
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-300, 0), for: .default)
    }
    
    func setupLeftMenuButton() {
        let menuButton = UIBarButtonItem.init(image: UIImage(named: "MenuIcon"), style: .plain, target: self, action: #selector(UIViewController.leftMenuButtonTapped))
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    
    func hideBackButton() {
        self.navigationItem.leftBarButtonItem = nil
    }
    
    private func isFirstViewControllerVisbibleViewController() -> Bool {
        return self.navigationController?.viewControllers.first == self.navigationController!.visibleViewController;
    }
    
    private func backButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem.init(image: nil, style: .plain, target: self, action: #selector(UIViewController.backButtonTapped))
    }
    
    @objc private func backButtonTapped() {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func popToRoot() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func leftMenuButtonTapped() {
        
    }
}
