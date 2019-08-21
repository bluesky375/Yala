//
//  HomeSegmentViewController.swift
//  Yala
//
//  Created by Ankita on 27/02/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit

class HomeSegmentViewController: UIViewController {
    
    var homeTabVC: HomeTabViewController!
    var segmentControl: UISegmentedControl!
    
    var selectedTabIndex = 0
    
    class func fromStoryboard() -> HomeSegmentViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: HomeSegmentViewController.self)) as! HomeSegmentViewController
        return viewController
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentControl()
        navigationController?.setNavigationBarAppearance(toType: .gradient)
        
        setLeftHamburgerButtonToShowMenu(withImage: (UIImage.init(named: "menu_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))!)
    }
    
    func configView(){
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.segmentControl.selectedSegmentIndex = selectedTabIndex
    }
    
    func setupSegmentControl() {
        segmentControl = UISegmentedControl(items: [UIImage.init(named: "america"), UIImage.init(named: "couple"), UIImage.init(named: "profile_icon")])
        segmentControl.setWidth(80, forSegmentAt: 0)
        segmentControl.setWidth(80, forSegmentAt: 1)
        segmentControl.setWidth(80, forSegmentAt: 2)
        segmentControl.sizeToFit()
        segmentControl.tintColor = UIColor.white
        segmentControl.selectedSegmentIndex = 0;
        segmentControl.addTarget(self, action: #selector(changeTab), for: .valueChanged)
        self.navigationItem.titleView = segmentControl
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HomeTabViewController,
            segue.identifier == "HomeTabViewController" {
            vc.selectedTabIndex = selectedTabIndex
            self.homeTabVC = vc
        }
    }
    
    @objc func changeTab() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedTabIndex = 0
            homeTabVC.selectedIndex = 0
            break
        case 1:
            selectedTabIndex = 1
            homeTabVC.selectedIndex = 1
            break
        case 2:
            selectedTabIndex = 2
            homeTabVC.selectedIndex = 3
            break
        default:
            break
        }
    }
}
