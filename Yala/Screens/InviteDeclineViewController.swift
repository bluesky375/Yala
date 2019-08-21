//
//  InviteDeclineViewController.swift
//  Yala
//
//  Created by Admin on 4/4/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit

import UIKit
import EventKit

class InviteDeclineViewController: UIViewController {
    
    var invite : Invite!
    var notification : YalaNotification!
    
    @IBOutlet weak var btnMessageUser: BorderedButton!
    @IBOutlet weak var btnCallUser: BorderedButton!
    
    @IBOutlet weak var lblMessageUSer: UILabel!
    @IBOutlet weak var lblCallUser: UILabel!
    
    var txtUserPhone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    func configView(){
        btnMessageUser.setBorder(side: .Bottom , UIColor.lightGray , 0.5)
        btnCallUser.setBorder(side: .Bottom , UIColor.lightGray , 0.5)
       
        let txtUserName = invite.invitingFriendName ?? "Will Smith"
        let txtUserEmail = invite.invitingFriendEmail ?? "unknown"
        txtUserPhone = invite.phoneNumber ?? "+0004151111"
        
        lblMessageUSer.text = "Message " + txtUserEmail
        lblCallUser.text = "Call " + txtUserPhone
      
    }
    
    class func fromStoryboard() -> InviteDeclineViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: InviteDeclineViewController.self)) as! InviteDeclineViewController
        return viewController
    }
   
    
    @IBAction func messageAction(_ sender: Any) { RootViewControllerFactory.shared.configureRootViewController(forType: .home(1), window: self.view.window!, animated: false)
    }
    
    @IBAction func onCallToSomebody(_ sender: Any) {
        print(txtUserPhone)
        dialNumber(number: txtUserPhone)
        
    }
    
    
    @IBAction func onTappedClose(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        let vcs = self.navigationController?.viewControllers
        for vc in vcs! {
            if vc is ActivitiesViewController {
                let newVc = vc as! ActivitiesViewController
                self.navigationController?.popToViewController(newVc, animated: true)
                break
            }
        }
        NotificationCenter.default.post(name : NSNotification.Name(rawValue: "accept_invite"), object : self.invite)
    }
    
    
    
    
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    
    
}
