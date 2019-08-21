//
//  ActivityConfirmationViewController.swift
//  Yala
//
//  Created by Ankita on 30/10/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import EventKit

class ActivityConfirmationViewController: UIViewController {
    
    @IBOutlet weak var inviteMessage: UILabel!
    var notification: YalaNotification!
    var backButtonAction: (()->())?
    class func fromStoryboard() -> ActivityConfirmationViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ActivityConfirmationViewController.self)) as! ActivityConfirmationViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Activity Confirmation"
        navigationController?.setNavigationBarAppearance(toType: .gradient)
        if backButtonAction != nil {
            setupBackButton(withAction: #selector(backButton))
        } else {
            setupBackButtonWhite()
        }
        inviteMessage.text = notification.message
    }
    
    @IBAction func confirmInviteAction(_ sender: Any) {
        SpinnerWrapper.showSpinner()
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
    
    @IBAction func messageAction(_ sender: Any) {
         RootViewControllerFactory.shared.configureRootViewController(forType: .home(1), window: self.view.window!, animated: false)
    }
    
    @IBAction func declineInviteAction(_ sender: Any) {
        SpinnerWrapper.showSpinner()
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
    
    @IBAction func mapAction(_ sender: Any) {

        if notification.lat != nil , notification.long != nil {
            OpenMaps.openInMaps(notification.lat!, notification.long!, "invited location")
        }
    }
    
    @IBAction func addToCalendarAction(_ sender: Any) {
        let eventStore : EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) {[weak self] (granted, error) in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = self?.notification.message
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
                event.startDate = date
                event.endDate = date
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                self?.showAlert(withTitle: "", message: "Event saved to caledar!")
            }
            else{
                print("failed to save event with error : \(error) or access not granted")
            }
        }
    }
    
    @objc func backButton() {
        if backButtonAction != nil {
            backButtonAction!()
        }
    }
}
