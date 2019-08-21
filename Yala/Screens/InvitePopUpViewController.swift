//
//  InvitePopUpViewController.swift
//  Yala
//
//  Created by Admin on 4/2/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit
import iOSDropDown
class InvitePopUpViewController: UIViewController {

    var invite: Invite! = Invite.init()
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblInviteTime: UILabel!
    @IBOutlet weak var btnDropdown: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        onConfigView()
    }
    
    class func fromStoryboard() -> InvitePopUpViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: InvitePopUpViewController.self)) as! InvitePopUpViewController
        return viewController
    }
    
    func onConfigView(){
        lblUserName.text = "by " + (invite.invitingFriendName ?? "Will Smith")
        lblLocation.text = "to " + (invite.locationName ?? "")
        lblInviteTime.text = "on " + invite.inviteDate() + " " + invite.inviteTime()
        btnDropdown.optionArray = ["Accept", "Decline"]
        btnDropdown.didSelect{(selectedText , index ,id) in
            print("selected \(index)")
            
            switch (index){
            case 0:
                self.accept_invite((Any).self)
                break
            case 1:
                self.decline_invite((Any).self)
                break
            default:
                break
            }
        }
    }
    
    
     @IBAction func accept_invite(_ sender: Any){
        
        SpinnerWrapper.showSpinner()
     
        let vc = InviteAcceptViewController.fromStoryboard()
        vc.invite = invite
        let notification = YalaNotification()
        notification.event = invite.id
        vc.notification = notification
        
        UserService.shared.acceptInvite(notification) { [weak self] (sucess, error, response) in
            SpinnerWrapper.hideSpinnerView()
            if response != nil, response?.inviteStatus == "1" {
//                self?.showAlert(withTitle: "", message: "Invite has been accepted successfully", postDismisshandler: {
//                })
                 self?.navigationController?.pushViewController(vc, animated: true)
                
            } else if response != nil, response?.message != nil {
      //          self?.showAlert(withTitle: "", message: response?.message)
            } else {
                self?.showAlert(withTitle: "", message: "Something went wrong, please try again later.")
            }
        }
    }
    
    @IBAction func decline_invite(_ sender: Any){
      
        let vc = InviteDeclineViewController.fromStoryboard()
        vc.invite = invite
        SpinnerWrapper.showSpinner()
        let notification = YalaNotification()
        notification.event = invite.id
        vc.notification = notification
        
        UserService.shared.declineInvite(notification) { [weak self] (sucess, error, response) in
            SpinnerWrapper.hideSpinnerView()
            if response != nil, response?.inviteStatus == "2" {
//                self?.showAlert(withTitle: "", message: "Invite has been declined.", postDismisshandler: {
//                   
//                })
                 self?.navigationController?.pushViewController(vc, animated: true)
            } else if response != nil, response?.message != nil {
                self?.showAlert(withTitle: "", message: response?.message)
            } else {
                self?.showAlert(withTitle: "", message: "Something went wrong, please try again later.")
            }
        }
        
    }
    
    

}

