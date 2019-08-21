//
//  InviteDetailViewController.swift
//  Yala
//
//  Created by Ankita on 18/12/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

class InvitedFriendCell: UITableViewCell {
    
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    func configureCell(_ friend: InvitedFriend) {
        nameLabel.text = friend.displayName()
        emailLabel.text = friend.email
        actionLabel.text = friend.displayStatus()
        
        if friend.status == "1" {
            actionLabel.textColor = UIColor.green
        } else if friend.status == "2" {
            actionLabel.textColor = UIColor.red
        } else {
            actionLabel.textColor = UIColor.orange
        }
    }
}

class InviteDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letsGoButton: YalaSelectionButton!
    @IBOutlet weak var notNowButton: YalaSelectionButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var letsGoHeightConstraint: NSLayoutConstraint!
    
    var invite: Invite!
    
    class func fromStoryboard() -> InviteDetailViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: InviteDetailViewController.self)) as! InviteDetailViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Invite Detail"
        setupBackButton()
        tableView.tableFooterView = UIView()
        setupData()
    }
    
    func setupData() {
        if invite.isCreatedByMe == true {
             titleLabel.text = "You have invited your friend(s) at " + invite.locationName! + " on " + invite.inviteDate() + " at " + invite.inviteTime()
            
            letsGoButton.isHidden = true
            notNowButton.isHidden = true
            letsGoHeightConstraint.constant = 0
        } else {
             titleLabel.text = "You are invited at " + invite.locationName! + " on " + invite.inviteDate() + " at " + invite.inviteTime() 
            letsGoButton.isHidden = false
            notNowButton.isHidden = false
        }
    }

    @IBAction func notNowAction(_ sender: Any) {
        SpinnerWrapper.showSpinner()
        
        let notification = YalaNotification()
        notification.event = invite.id
        
        UserService.shared.declineInvite(notification) { [weak self] (sucess, error, response) in
            SpinnerWrapper.hideSpinnerView()
            if response != nil, response?.inviteStatus == "2" {
                self?.showAlert(withTitle: "", message: "Invite has been declined.", postDismisshandler: {
                    self?.navigationController?.popViewController(animated: true)
                })
            } else if response != nil, response?.message != nil {
                self?.showAlert(withTitle: "", message: response?.message)
            } else {
                self?.showAlert(withTitle: "", message: "Something went wrong, please try again later.")
            }
        }
    }
    
    @IBAction func letsGoAction(_ sender: Any) {
        SpinnerWrapper.showSpinner()
        
        let notification = YalaNotification()
        notification.event = invite.id
        
        UserService.shared.acceptInvite(notification) { [weak self] (sucess, error, response) in
            SpinnerWrapper.hideSpinnerView()
            if response != nil, response?.inviteStatus == "1" {
                self?.showAlert(withTitle: "", message: "Invite has been accepted successfully", postDismisshandler: {
                    self?.navigationController?.popViewController(animated: true)
                })
                
            } else if response != nil, response?.message != nil {
                self?.showAlert(withTitle: "", message: response?.message)
            } else {
                self?.showAlert(withTitle: "", message: "Something went wrong, please try again later.")
            }
        }
    }
    
}

extension InviteDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invite.invitedFriends != nil ? (invite.invitedFriends?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitedFriendCell") as! InvitedFriendCell
        
        let friend = invite.invitedFriends![indexPath.row]
        cell.configureCell(friend)
        
        return cell
    }
}
