//
//  SideMenuViewController.swift
//  Coverati
//
//  Created by Ankita Porwal on 04/02/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import Kingfisher
import MessageUI
import Messages

enum SideMenuItemType {
    case profile, favorite, friends, messages, history, aboutUs, settings, faq, logout, contactUs, privacyPolicy, feedbacks
}

struct SideMenuItem {
    var imageName: String
    var labelName: String
    var type: SideMenuItemType
    
    init(_ imageName: String, _ labelName: String, _ type: SideMenuItemType) {
        self.imageName = imageName
        self.labelName = labelName
        self.type = type
    }
}

class SideMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    func configureCell(_ item: SideMenuItem) {
        itemImageView.image = UIImage.init(named: item.imageName)
        itemNameLabel.text = item.labelName
    }
}

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UIButton!
    @IBOutlet weak var profileImageView: CircularImageView!
    
    var items = [SideMenuItem.init("profile", "Profile", .profile),
                 SideMenuItem.init("profile", "Friends", .friends),
                 SideMenuItem.init("history", "History", .history),
                 SideMenuItem.init("profile", "Feedbacks", .feedbacks),
                 SideMenuItem.init("FAQ", "Privacy Policy", .privacyPolicy),
                 SideMenuItem.init("logout", "Logout", .logout)]
    
    class func fromStoryboard() -> SideMenuViewController {
        let homevC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: SideMenuViewController.self)) as! SideMenuViewController
        return homevC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupTableView()
        ListenerDispatcher.shared.addListener(self, eventType: UpdateProfileEvent.self, OperationQueue.main)
        displayUsername()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupAppearance() {
        let color1 = UIColor.init(rgb: 0x2490d8)
        let color2 = UIColor.init(rgb: 0x0061d8)
        headerView.applyHorizontalGradient(colors: [color1, color2])
        view.applyHorizontalGradient(colors: [color1, color2])
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        let imageView = UIImageView.init(image: UIImage.init(named: "leftmenu_bg_image"))
        imageView.frame = tableView.frame
        tableView.backgroundView = imageView
    }
    
    func displayUsername() {
        let user = User.loadCurrentUser()
        usernameLabel.setTitle(user?.displayName(), for: .normal)
        if user?.profileimage != nil && user?.profileimage != "" {
            profileImageView.kf.setImage(with: URL(string: user!.profileimage!)!, placeholder: UIImage(named: "empty_profile_icon"), options: [.cacheOriginalImage])
        }
    }
    
    @IBAction func openProfileAction() {
        closeLeft()
        let vc = ProfileViewController.fromStoryboard()
        vc.user = User.loadCurrentUser()
        let navController = CustomNavigationController.init(rootViewController: vc)
        navController.lightStatusBar = true
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
}

extension SideMenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
        let item = items[indexPath.row]
        cell.configureCell(item)
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if item.type == .logout {
            UserAccountManager.shared.removeTokens()
            RootViewControllerFactory.shared.configureRootViewController(forType: .landing, window: self.view.window!, animated: true)
            ServicesManager.instance().logout {
                ServicesManager.instance().chatService.disconnect()
            }
            ServicesManager.instance().logout(completion: nil)
        } else if item.type == .profile {
            closeLeft()
            let vc = ProfileViewController.fromStoryboard()
            vc.user = User.loadCurrentUser()
            let navController = CustomNavigationController.init(rootViewController: vc)
            navController.lightStatusBar = true
            self.navigationController?.present(navController, animated: true, completion: nil)
        } else if item.type == .history {
            let vc = ActivitiesViewController.fromStoryboard()
            let navController = CustomNavigationController.init(rootViewController: vc)
            navController.lightStatusBar = true
            self.navigationController?.present(navController, animated: true, completion: nil)
        } else if item.type == .aboutUs {
            let vc = WebViewController.fromStoryboard()
            vc.screenTitle = "About Us"
            vc.urlStr = "http://dev.w3ondemand.com/development/yala/about-us/"
            let navController = CustomNavigationController.init(rootViewController: vc)
            navController.lightStatusBar = true
            self.navigationController?.present(navController, animated: true, completion: nil)
        } else if item.type == .contactUs {
            let vc = WebViewController.fromStoryboard()
            vc.screenTitle = "Contact Us"
            vc.urlStr = "http://dev.w3ondemand.com/development/yala/contact-us/"
            let navController = CustomNavigationController.init(rootViewController: vc)
            navController.lightStatusBar = true
            self.navigationController?.present(navController, animated: true, completion: nil)
        } else if item.type == .privacyPolicy {
            let vc = WebViewController.fromStoryboard()
            vc.screenTitle = "Privacy Policy"
            vc.urlStr = "http://dev.w3ondemand.com/development/yala/privacy-policy/"
            let navController = CustomNavigationController.init(rootViewController: vc)
            navController.lightStatusBar = true
            self.navigationController?.present(navController, animated: true, completion: nil)
        } else if item.type == .feedbacks {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["yalaapp.development@gmail.com"])
                
                present(mail, animated: true)
            } else {
                self.showAlert(withTitle: "Mail not configured", message: "Please configure your email in Mail app and then proceed.")
            }
        } else if item.type == .friends  {
            closeLeft()
            let vc = FriendsViewController.fromStoryboard()
            vc.showBackButton = true
            vc.backButtonHandler = {
                vc.dismiss(animated: true, completion: nil)
            }
            let navController = CustomNavigationController.init(rootViewController: vc)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }
}

//  MARK:- ListenerDispatcherProtocol methods

extension SideMenuViewController: ListenerDispatcherProtocol {
    
    func didFireEventWithDispatcher(_ dispatcher: ListenerDispatcher, withEvent event: AnyObject) {
        if type(of: event) === UpdateProfileEvent.self {
            displayUsername()
        }
    }
}

extension SideMenuViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            self.showAlert(withTitle: "Feedback sent", message: "Thank you for your feedback!", okButtonTitle: "OK") { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            
        default:
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
