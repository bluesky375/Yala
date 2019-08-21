//
//  FriendsViewController.swift
//  Yala
//
//  Created by Ankita on 10/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import SVProgressHUD
import BEMCheckBox
import Kingfisher
import EMSpinnerButton
import MessageUI
import CoreLocation
import Messages

enum FriendCellType {
    case checkBox, invite
}

class FriendCell: UITableViewCell {
    @IBOutlet weak var profileImageView: CircularImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var facebookView: BorderedView!
    @IBOutlet weak var contactView: BorderedView!
    @IBOutlet weak var yalaUserView: RoundedView!
    @IBOutlet weak var inviteButton: ActivityButton!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var friend: Friend!
    
    var didTapInvite: (()->())?
    var didSelectCheckBox: ((_ isSelected: Bool)->())?
    
    override func prepareForReuse() {
        checkBox.on = false
    }
    
    func configure(_ friend: Friend, _ cellType: FriendCellType) {
        self.friend = friend
        
        nameLabel.text = friend.displayName()
        if friend.email != nil || friend.email != "" {
            subtitleLabel.text = friend.email
        }
        
        subtitleLabel.text = nil
        
        if friend.profileImage != nil && friend.profileImage != "" {
            profileImageView.kf.setImage(with: URL(string: friend.profileImage!), placeholder: UIImage(named: "empty_profile_icon"), options: [.cacheOriginalImage])
        } else {
            profileImageView.image = UIImage.init(named: "empty_profile_icon")
        }
        
        if friend.isYalaUser() {
            yalaUserView.isHidden = false
        } else {
            yalaUserView.isHidden = true
        }
        
        let isYalaUser = friend.isYalaUser()
        
        if cellType == .checkBox {
            checkBox.isHidden = false
            inviteButton.isHidden = true
        } else {
            checkBox.isHidden = true
            inviteButton.isHidden = isYalaUser
        }
        
        if friend.facebookId != nil && friend.facebookId != "" {
            facebookView.isHidden = false
            contactView.isHidden = true
        } else {
            facebookView.isHidden = true
            contactView.isHidden = false
        }
        
        let lastDeviceLongitude = UserService.shared.lastDeviceLongitude
        let lastDeviceLatitude = UserService.shared.lastDeviceLatitude
        
        if lastDeviceLongitude != nil, lastDeviceLatitude != nil, friend.latitude != nil, friend.longitude != nil {
            
            var userLocation: CLLocation?
            if let lat =  CLLocationDegrees(lastDeviceLatitude!), let long = CLLocationDegrees(lastDeviceLongitude!) {
                userLocation = CLLocation.init(latitude: lat, longitude: long)
            }
            
            var friendLocation: CLLocation?
            if let lat =  CLLocationDegrees(friend.latitude!), let long = CLLocationDegrees(friend.longitude!) {
                friendLocation =  CLLocation.init(latitude: lat, longitude: long)
            }
            
            if friendLocation != nil {
                let airDistance = userLocation?.distanceFrom(friendLocation!)
                if airDistance != nil {
                    distanceLabel.text = airDistance!.toMiles()
                } else {
                    distanceLabel.text = nil
                }
            } else {
                distanceLabel.text = nil
            }
        } else {
            distanceLabel.text = nil
        }
    }
    
    @IBAction func inviteButtonAction(_ sender: Any) {
        if didTapInvite != nil {
            didTapInvite!()
        }
    }
}

extension FriendCell: BEMCheckBoxDelegate {
    
    func didTap(_ checkBox: BEMCheckBox) {
        if didSelectCheckBox != nil {
            didSelectCheckBox!(checkBox.isEnabled)
        }
    }
}

class FriendsViewController: UIViewController, VisibleTabBarProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonView: UIView!
    
    var cellType: FriendCellType = .invite
    
    var user: User!
    var friends = [Friend]()
    var selectedFriends = [Friend]()
    var invite: Invite?
    
    var syncButton: EMSpinnerButton?
    var submitButton: EMSpinnerButton?
    
    var showBackButton: Bool = false
    var showTabBar: Bool = true
    
    var backButtonHandler: (()->())?
    
    var refreshControl: UIRefreshControl!

    class func fromStoryboard() -> FriendsViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: FriendsViewController.self)) as! FriendsViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Friends"
        navigationController?.setNavigationBarAppearance(toType: .gradient)
        
        if showBackButton {
            setupBackButton(withAction: #selector(backButtonAction))
        } else {
            setLeftHamburgerButtonToShowMenu(withImage: (UIImage.init(named: "menu_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))!)
        }
        
        setupTableView()
        
        user = User.loadCurrentUser()
        fetchUserFriendlist(true)
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func setupBarButtons() {
        if syncButton == nil {
            let sync = EMSpinnerButton.init(title: "Sync Friends")
            sync.backgroundColor = UIColor.clear
            sync.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            sync.addTarget(self, action: #selector(FriendsViewController.syncFriendAction), for: .touchUpInside)
            
            syncButton = sync
        }
        
        if submitButton == nil {
            let saveSpinnerButton1 = EMSpinnerButton.init(title: "Submit")
            saveSpinnerButton1.backgroundColor = UIColor.clear
            saveSpinnerButton1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            saveSpinnerButton1.addTarget(self, action: #selector(FriendsViewController.submitButtonAction), for: .touchUpInside)
            
            submitButton = saveSpinnerButton1
        }
        
        if selectedFriends.count > 0 {
            let submitBarButton = UIBarButtonItem(customView: submitButton!)
            navigationItem.rightBarButtonItem = submitBarButton
        } else if friends.count > 0 {
            let syncBarButton = UIBarButtonItem(customView: syncButton!)
            navigationItem.rightBarButtonItem = syncBarButton
        }
    }
    
    @IBAction func syncFriendAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let fb = UIAlertAction.init(title: "Facebook Friends", style: .default) { [weak self] _ in
            alert.dismiss(animated: true, completion: nil)
            self?.fetchFBFriendList({ (friends) in
                if friends != nil, (friends?.count)! > 0 {
                    self?.syncFriends(friends!)
                } else {
                    SpinnerWrapper.hideSpinnerView()
                    self?.showAlert(withTitle: "", message: "Sorry, We couldn't find your facebook friend who are using Yala this time with facebook login. Please try other friend sync methods.")
                }
            })
        }
        alert.addAction(fb)
        
        let contacts = UIAlertAction.init(title: "Contacts", style: .default) {[weak self] _ in
            alert.dismiss(animated: true, completion: nil)
            
            let friends = PhoneContacts.getContactFriends()
            if friends.count > 0 {
                self?.syncFriends(friends)
            }
        }
        
        alert.addAction(contacts)
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    func syncFriends(_ friends: [Friend]) {
        SpinnerWrapper.showSpinner()
        UserService.shared.syncFriends((user)!, friends, completionHandler: { [weak self] (success, error) in
            SpinnerWrapper.hideSpinnerView()
            if success {
                self?.showAlert(withTitle: "", message: "Congratualations! Your friends are now synced with Yala app.", postDismisshandler: {
                    self?.fetchUserFriendlist(true)
                }) 
            } else {
                self?.showAlert(withTitle: "", message: "Something went wrong while syncing your friends, please try after some time.")
            }
        })
    }
    
    @objc func fetchUserFriendlist(_ withSpinner: Bool) {
        if withSpinner == true {
            SpinnerWrapper.showSpinner()
        }
        
        UserService.shared.getFriends(user) { [weak self] (success, error, friends) in
            SpinnerWrapper.hideSpinnerView()
            self?.refreshControl.endRefreshing()
            
            if friends != nil, (friends?.count)! > 0 {
                self?.tableView.isHidden = false
                self?.friends = friends!
            self?.buttonView.isHidden = true
                self?.tableView.reloadData()
                self?.setupBarButtons()
            } else {
                self?.setupBarButtons()
                self?.tableView.isHidden = true
                self?.buttonView.isHidden = false
            }
        }
    }
    
    @objc func submitButtonAction() {
        invite?.friends = selectedFriends
        
        if invite?.containsYalaFriends() == false {
            self.composeMessage(invite!)
            return
        }
        
        submitButton?.animate(animation: .collapse)
        UserService.shared.createInvite(invite!) { [weak self] (success, response, error) in
            self?.submitButton?.animate(animation: .expand)
            if response?.error == false {
                if self?.invite?.containsNonYalaFriends() == true {
                    self?.showAlert(withTitle: "Invite Sent", message: "Invite has been sent successfully to all your friends who are on Yala platform. Please proceeed to send separate message to those who are not on yala yet.", okButtonTitle: "Proceed", postDismisshandler: {
                        self?.composeMessage((self?.invite)!)
                    })
                } else {
                    self?.showAlert(withTitle: "Invite Sent", message: "Invite has been sent successfully to all friends. Stay tuned for their responses.", okButtonTitle: "Ok", postDismisshandler: {
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                }
               
            } else if response?.message != nil {
                self?.showAlert(withTitle: nil, message: response?.message)
            } else {
                self?.showAlert(withTitle: nil, message: "Something went wrong, please try again later.")
            }
        }
    }
    
    func composeEmail(_ invite: Invite) {
        var recipients = [String]()
        
        for user in invite.friends! {
            if !user.isYalaUser() && user.email != nil && user.email != "" {
                recipients.append(user.email!)
            }
        }
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(recipients)
            mail.setMessageBody(invite.invitationMessage(), isHTML: false)
            
            present(mail, animated: true)
        } else {
            self.showAlert(withTitle: "Mail not configured", message: "Please configure your email in Mail app and then proceed.")
        }
    }
    
    func composeMessage(_ invite: Invite) {
        var recipients = [String]()
        
        for user in invite.friends! {
            if !user.isYalaUser() && user.mobile != nil && user.mobile != "" {
                recipients.append(user.mobile!)
            }
        }
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = invite.invitationMessage()
            controller.recipients = recipients
            controller.messageComposeDelegate = self
            present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func refresh(_ sender: Any) {
        fetchUserFriendlist(false)
    }
    
    @objc func backButtonAction() {
        if backButtonHandler != nil {
            backButtonHandler!()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension FriendsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendCell
        let friend = friends[indexPath.row]
        cell.configure(friend, cellType)
        cell.checkBox.on = selectedFriends.contains(friend)
        cell.didSelectCheckBox = { [weak self] (isSelected) in
            if isSelected && ((self?.selectedFriends) != nil) && !(self?.selectedFriends.contains(friend))! {
                self?.selectedFriends.append(friend)
            } else if ((self?.selectedFriends) != nil) && (self?.selectedFriends.contains(friend))! {
                let index = self?.selectedFriends.index(of: friend)
                if (index != nil) {
                    self?.selectedFriends.remove(at: index!)
                }
            }
            
            self?.setupBarButtons()
        }
        
        cell.didTapInvite = {
            let user = User.loadCurrentUser()
            let text = (user?.displayName())! + " has invited you to Yala - Let's Go. Please download the app from https://itunes.apple.com/app/id1436412394"
            let textShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }

        return cell
    }
}


extension FriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        
        let user = User()
        user.firstName = friend.firstName
        user.lastName = friend.lastName
        user.mobile = friend.mobile
        user.email = friend.email
        user.gender = friend.gender
        user.dob = friend.dob
        user.job = friend.job
        user.aboutYou = friend.aboutYou
        user.college = friend.college
        user.country = friend.country
        user.address = friend.address
        user.profileimage = friend.profileImage
        
        let vc = ProfileViewController.fromStoryboard()
        vc.showEditButton = false
        vc.user = user
        vc.dismissAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension FriendsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            self.showAlert(withTitle: "Invite Sent", message: "Stay tuned for your friends responses", okButtonTitle: "OK") { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            
        default:
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension FriendsViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
