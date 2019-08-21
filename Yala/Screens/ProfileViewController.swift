//
//  ProfileViewController.swift
//  Yala
//
//  Created by Ankita on 18/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func prepareForReuse() {
        titleLabel.text = ""
        valueLabel.text = ""
    }
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: CircularImageView!
    @IBOutlet weak var nameButton: UIButton!
    
    var user: User!
    var showEditButton = true
    var dismissAction: (()->())?
    
    class func fromStoryboard() -> ProfileViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as! ProfileViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        navigationController?.setNavigationBarAppearance(toType: .gradient)
        setupBackButton(withAction: #selector(ProfileViewController.dismissMe))
        setupTableView()
        
        displayData()
        ListenerDispatcher.shared.addListener(self, eventType: UpdateProfileEvent.self, OperationQueue.main)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
        displayData()
    }
    
    func displayData() {
        if user.profileimage != nil {
            profileImageView.kf.setImage(with: URL(string: user.profileimage!), placeholder: UIImage(named: "ic_profile"), options: [.cacheOriginalImage])
        }
        
        nameButton.setTitle(user.displayName(), for: .normal)
        nameButton.isEnabled = showEditButton
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    @objc func dismissMe() {
        if dismissAction != nil {
            dismissAction!()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func editProfileAction() {
        let editViewController = EditProfileViewController.fromStoryboard()
        let customVC = CustomNavigationController.init(rootViewController: editViewController)
        
        navigationController?.present(customVC, animated: true, completion: nil)
    }
}

extension ProfileViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Email"
            cell.valueLabel.text = (user.email ?? "").isEmpty ? "-" : user.email
            break
        case 1:
            cell.titleLabel.text = "About you"
            cell.valueLabel.text = (user.aboutYou ?? "").isEmpty ? "-" : user.aboutYou
            break
        case 2:
            cell.titleLabel.text = "Mobile Number"
            cell.valueLabel.text = (user.mobile ?? "").isEmpty ? "-" : user.mobile
            break
        case 3:
            cell.titleLabel.text = "Gender"
            cell.valueLabel.text = (user.displayGenderValue() ?? "").isEmpty ? "-" : user.displayGenderValue()
            break
        default:
            break
        }
        
        return cell
    }
}

//  MARK:- ListenerDispatcherProtocol methods

extension ProfileViewController: ListenerDispatcherProtocol {
    
    func didFireEventWithDispatcher(_ dispatcher: ListenerDispatcher, withEvent event: AnyObject) {
        if type(of: event) === UpdateProfileEvent.self {
            user = User.loadCurrentUser()
            displayData()
        }
    }
}
