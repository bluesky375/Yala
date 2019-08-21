//
//  HomeTabViewController.swift
//  Yala
//
//  Created by Ankita on 10/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import Quickblox

@objc protocol VisibleTabBarProtocol {
}

class HomeTabViewController: UITabBarController {
    
    var nearbyNavigationController: CustomNavigationController!
    var messagesNavigationController: CustomNavigationController!
    var friendsNavigationController: CustomNavigationController!
    var notificationsNavigationController: CustomNavigationController!
    var selectedTabIndex: Int = 0
    var pageIndexToLoad: Int = 0
    
    class func fromStoryboard() -> HomeTabViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: HomeTabViewController.self)) as! HomeTabViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = #colorLiteral(red: 0.231372549, green: 0.6235294118, blue: 0.8274509804, alpha: 1)
        tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupViewControllers()
        self.selectedIndex = selectedTabIndex
        updateBlobId()
        is_new_invites()
        tabBar.isHidden = true
    }
    func is_new_invites(){
        let user: User! = User.init()
        UserService.shared.getStateNewInvite(user) { [weak self] (success, error, Response) in
            print("new invite status : ", Response as Any)
          
            if(((Response ?? "") as String) == "yes"){
//                let vc = ActivitiesViewController.fromStoryboard()
//                self?.navigationController!.pushViewController(vc, animated: true)
                let vc = ActivitiesViewController.fromStoryboard()
                let navController = CustomNavigationController.init(rootViewController: vc)
                navController.lightStatusBar = true
                self?.navigationController?.present(navController, animated: true, completion: nil)
            }
        }
    }
    
    func setupViewControllers() {
        let vc1 = nearbyViewController()
        let vc2 = messageViewController()
        let vc3 = friendsViewController()
        let vc4 = notificationsViewController()
        let controllers = [vc1, vc2, vc3, vc4]
        self.viewControllers = controllers
    }
    
    func nearbyViewController() -> UIViewController {
        let homeVC = NearbyViewController.fromStoryboard()
//        let homeVC = FeedsViewController.fromStoryboard()
        let navVC = CustomNavigationController(rootViewController: homeVC)
        navVC.lightStatusBar = true
        navVC.delegate =  self
        let tabBarImage = UIImage(named: "nearby_tab")!
        let selectedTabBarImage = UIImage(named: "nearby_tab_selected")?.withRenderingMode(.alwaysOriginal)
        navVC.tabBarItem = UITabBarItem(title: "Nearby", image: tabBarImage, selectedImage: selectedTabBarImage)
        navVC.tabBarItem.titlePositionAdjustment.vertical = -3
        return navVC
    }
    
    func messageViewController() -> UIViewController {
        let homeVC = FeedsViewController.fromStoryboard()
//        let homeVC = FriendsViewController.fromStoryboard()
        let navVC = CustomNavigationController(rootViewController: homeVC)
        navVC.lightStatusBar = true
        navVC.delegate =  self
        let tabBarImage = UIImage(named: "message_tab")!
        let selectedTabBarImage = UIImage(named: "message_tab_selected")?.withRenderingMode(.alwaysOriginal)
        navVC.tabBarItem = UITabBarItem(title: "Messages", image: tabBarImage, selectedImage: selectedTabBarImage)
        navVC.tabBarItem.titlePositionAdjustment.vertical = -3
        return navVC
    }
    
    func friendsViewController() -> UIViewController {
        print("friends selected")
        let homeVC = FriendsViewController.fromStoryboard()

  //      let homeVC = FeedsViewController.fromStoryboard()
        
        let navVC = CustomNavigationController(rootViewController: homeVC)
        navVC.lightStatusBar = true
        navVC.delegate =  self
        let tabBarImage = UIImage(named: "user_tab")!
        let selectedTabBarImage = UIImage(named: "user_tab_selected")?.withRenderingMode(.alwaysOriginal)
        navVC.tabBarItem = UITabBarItem(title: "Friends", image: tabBarImage, selectedImage: selectedTabBarImage)
        navVC.tabBarItem.titlePositionAdjustment.vertical = -3
        return navVC
    }
    
    func notificationsViewController() -> UIViewController {
        let homeVC = NotificationViewController.fromStoryboard()
 //       let homeVC = FeedsViewController.fromStoryboard()
        let navVC = CustomNavigationController(rootViewController: homeVC)
        navVC.lightStatusBar = true
        navVC.delegate =  self
        let tabBarImage = UIImage(named: "notification_tab")!
        let selectedTabBarImage = UIImage(named: "notification_tab_selected")?.withRenderingMode(.alwaysOriginal)
        navVC.tabBarItem = UITabBarItem(title: "Notifications", image: tabBarImage, selectedImage: selectedTabBarImage)
        navVC.tabBarItem.titlePositionAdjustment.vertical = -3
        return navVC
    }
    
    func updateBlobId() {
        let user = User.loadCurrentUser()
        let qbUser = QBUUser()
        qbUser.login = user!.email
        qbUser.password = user!.email
        qbUser.email = user!.email
        qbUser.fullName = user?.displayName()
        
        let enviroment = Constants.QB_USERS_ENVIROMENT
        qbUser.tags = [enviroment]
        
        ServicesManager.instance().authService.logIn(with: qbUser, completion: { (response, user) in
            
            if user == nil {
                ServicesManager.instance().authService.signUpAndLogin(with: qbUser) { (response, user) in
                    let userId = user?.id != nil ? (user?.id)! : 0
                    
                    ServicesManager.instance().chatService.connect(completionBlock: nil)
                    
                    APIManager.shared.request(PostChatIDAPIRequest.init(requestType: PostChatIDEndpoint.sentId(Int(userId))), completionHandler: { (success, response: GenericResponse?, _, _, error) in
                        
                    })
                }
            } else {
                let userId = user?.id != nil ? (user?.id)! : 0
                
                ServicesManager.instance().chatService.connect(completionBlock: nil)
                
                APIManager.shared.request(PostChatIDAPIRequest.init(requestType: PostChatIDEndpoint.sentId(Int(userId))), completionHandler: { (success, response: GenericResponse?, _, _, error) in
                    
                })
            }
        })
    }
}

extension HomeTabViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if let friendVC = viewController as? FriendsViewController {
//            tabBar.isHidden = !friendVC.showTabBar
//        } else {
//            tabBar.isHidden = !viewController.conforms(to: VisibleTabBarProtocol.self)
//        }
        
         tabBar.isHidden = true
    }
}
