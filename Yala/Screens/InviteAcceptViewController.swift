//
//  InviteAcceptViewController.swift
//  Yala
//
//  Created by Admin on 4/2/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit
import EventKit

class InviteAcceptViewController: UIViewController {

    var invite : Invite!
    var notification : YalaNotification!
    
    @IBOutlet weak var btnMessageUser: BorderedButton!
    @IBOutlet weak var btnCallUser: BorderedButton!
    @IBOutlet weak var btnAddToCalendar: BorderedButton!
    @IBOutlet weak var btnPayUser: BorderedButton!
    @IBOutlet weak var btnInviteUser: BorderedButton!
    
    @IBOutlet weak var lblMessageUSer: UILabel!
    @IBOutlet weak var lblCallUser: UILabel!
    @IBOutlet weak var lblPayUser: UILabel!
    
    var txtUserPhone = ""
    var eventStore : EKEventStore?  =  nil
    var event: EKEvent? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    func configView(){
        btnMessageUser.setBorder(side: .Bottom , UIColor.lightGray , 0.5)
        btnCallUser.setBorder(side: .Bottom , UIColor.lightGray , 0.5)
        btnAddToCalendar.setBorder(side: .Bottom , UIColor.lightGray , 0.5)
        btnPayUser.setBorder(side: .Bottom , UIColor.lightGray , 0.5)
        btnInviteUser.setBorder(side: .Bottom , UIColor.lightGray , 0.5)
        let txtUserName = invite.invitingFriendName ?? "Will Smith"
        let txtUserEmail = invite.invitingFriendEmail ?? "unknown"
        txtUserPhone = invite.phoneNumber ?? "+0004151111"
        
        lblMessageUSer.text = "Message " + txtUserEmail
        lblCallUser.text = "Call " + txtUserPhone
        lblPayUser.text = "Pay " + txtUserName
        
        eventStore = EKEventStore()
        event = EKEvent(eventStore: eventStore!)
        
        
    }

    class func fromStoryboard() -> InviteAcceptViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: InviteAcceptViewController.self)) as! InviteAcceptViewController
        return viewController
    }
    
    @IBAction func addToCalendarAction(_ sender: Any) {
        eventStore!.requestAccess(to: .event) {[weak self] (granted, error) in
            if (granted) && (error == nil) {
//                print("granted \(granted)")
//                print("error \(error)")
                
                self!.event!.title = self?.notification.message
                var date: Date?
                if let message = self?.notification.message {
                    var time = message.components(separatedBy: " at ").last
                    if time?.contains("today") == true {
                        time = time?.removeCharacters(characters: "today").trim() ?? ""
                        let dateString = (Date().toString(inFormat: "dd MMM YYYY") ?? "") + " " + time!
                        date = dateString.toDate()
                    } else {
                        var dateString = time?.components(separatedBy: ",").last?.trim()
                        time = time?.components(separatedBy: " on ").first?.trim() ?? ""
                        if dateString?.contains("with") == true {
                            dateString = dateString?.components(separatedBy: "with").first?.trim()
                        }
                        dateString = dateString! + " " + time!
                        date = dateString?.toDate()
                    }
                }
                self!.event!.startDate = date
                self!.event!.endDate = date
                self!.event!.calendar = self!.eventStore?.defaultCalendarForNewEvents
                do {
                    try self!.eventStore!.save(self!.event!, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
//                self?.showAlert(withTitle: "", message: )
                self?.alert(message: "Event saved to caledar!")
            }
            else{
                print("failed to save event with error : \(error) or access not granted")
            }
        }
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
    
    @IBAction func onTappedInviteFriends(_ sender: Any) {
        let vc = FriendsViewController.fromStoryboard()
        navigationController?.pushViewController(vc, animated: true)
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

enum BorderedButtonSide {
    case Top, Right, Bottom, Left
}


class BorderedButton : UIButton {
    
    private var borderTop: CALayer?
    private var borderTopWidth: CGFloat?
    private var borderRight: CALayer?
    private var borderRightWidth: CGFloat?
    private var borderBottom: CALayer?
    private var borderBottomWidth: CGFloat?
    private var borderLeft: CALayer?
    private var borderLeftWidth: CGFloat?
    
    
    func setBorder(side: BorderedButtonSide, _ color: UIColor, _ width: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
            borderTop?.removeFromSuperlayer()
            borderTop = border
            borderTopWidth = width
        case .Right:
            border.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
            borderRight?.removeFromSuperlayer()
            borderRight = border
            borderRightWidth = width
        case .Bottom:
            border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
            borderBottom?.removeFromSuperlayer()
            borderBottom = border
            borderBottomWidth = width
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
            borderLeft?.removeFromSuperlayer()
            borderLeft = border
            borderLeftWidth = width
        }
        
        layer.addSublayer(border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderTop?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderTopWidth!)
        borderRight?.frame = CGRect(x: frame.size.width - borderRightWidth!, y: 0, width: borderRightWidth!, height: frame.size.height)
        borderBottom?.frame = CGRect(x: 0, y: frame.size.height - borderBottomWidth!, width: frame.size.width, height: borderBottomWidth!)
        borderLeft?.frame = CGRect(x: 0, y: 0, width: borderLeftWidth!, height: frame.size.height)
    }
    
}
