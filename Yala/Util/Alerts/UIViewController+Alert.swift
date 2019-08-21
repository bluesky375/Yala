//
//  UIViewController+Alert.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

/**
    This extension on UIViewController provides easy to use alert display methods and handlers
 */

extension UIViewController {
    
    /**
     Shows an error in an alert
     */
    func showError(_ error: CustomError) {
        if error.title == nil {
            showAlert(withTitle: error.message, message: nil)
        } else {
            showAlert(withTitle: error.title, message: error.message)
        }
    }
    
    /**
     Shows an error in an alert
     
     If an error is TimedOut or NotConnectedToInternet it shows 'Ok' button in alert and on its tap provided handler is called
     */
    func showError(_ error: CustomError, withNetworkHandler handler: (() -> Void)?) {
        switch error.code {
        case URLError.timedOut.rawValue:
            fallthrough
        case URLError.notConnectedToInternet.rawValue:
            if handler != nil {
                if error.title == nil {
                    showAlert(withTitle: error.message, message: nil, okButtonTitle: "Ok", postDismisshandler: handler!)
                } else {
                    showAlert(withTitle: error.title, message: error.message, okButtonTitle: "Ok", postDismisshandler: handler!)
                }
            } else {
                fallthrough
            }
        default:
            showError(error)
        }
    }
    
    /**
     Shows an alert with provided title and message
     */
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)   
    }
    
    /**
     Shows an alert with provided title, message and 'Ok' button
     
     shouldDismissOnButtonTap:- if true then alert will be dismised on button tap
     buttonTapHandler will be called on tapping 'Ok' button
     */
    func showAlert(withTitle title: String?, message: String?, buttonTitle: String = "Ok", shouldDismissOnButtonTap: Bool, buttonTapHandler handler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: buttonTitle, style: .default) { _ in
            if shouldDismissOnButtonTap == true {
                alert.dismiss(animated: true, completion: nil)
            }
            handler()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    /**
     Shows an alert with provided title, message and 'Ok' button
     postDismisshandler will be called on 'Ok' button tap and alert dismissal
     */
    func showAlert(withTitle title: String?, message: String?, okButtonTitle: String = "Ok", postDismisshandler handler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: okButtonTitle, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            handler()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    /**
     Shows an alert with provided title, message, cancel and other button with title provided as argument
     
     cancelButtonPostHandler will be called on 'cancel' button tap and alert dismissal
     otherButtonPostHandler will be called on other button tap and alert dismissal
     */
    func showAlert(withTitle title: String?, message: String?, cancelButtonTitle: String, otherButtonTitle: String, cancelButtonPostHandler cancelHandler: (() -> Void)?, otherButtonPostHandler otherHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction.init(title: cancelButtonTitle, style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
            if cancelHandler != nil {
                cancelHandler!()
            }
        }
        alert.addAction(action1)
        
        let action2 = UIAlertAction.init(title: otherButtonTitle, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            otherHandler()
        }
        alert.addAction(action2)
        present(alert, animated: true)
    }
    
    /**
     Shows an alert with provided title, message, cancel and two other button with titles provided as argument
    
     cancelButtonPostHandler will be called on 'cancel' button tap and alert dismissal
     otherButtonPostHandler1 will be called on other button1 tap and alert dismissal
     otherButtonPostHandler2 will be called on other button2 tap and alert dismissal
     */
    func showAlert(withTitle title: String?, message: String?, cancelButtonTitle: String, otherButtonTitle1: String, otherButtonTitle2: String, cancelButtonPostHandler cancelHandler: (() -> Void)?, otherButtonPostHandler1 otherHandler1: @escaping () -> Void, otherButtonPostHandler2 otherHandler2: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction.init(title: cancelButtonTitle, style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
            if cancelHandler != nil {
                cancelHandler!()
            }
        }
        alert.addAction(action1)
        
        let action2 = UIAlertAction.init(title: otherButtonTitle1, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            otherHandler1()
        }
        alert.addAction(action2)
        
        let action3 = UIAlertAction.init(title: otherButtonTitle2, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            otherHandler2()
        }
        alert.addAction(action3)
        present(alert, animated: true)
    }
    
    /**
     Shows an alert with provided title, message, cancel and logout button with title provided as argument
     
     cancelButtonPostHandler will be called on 'cancel' button tap and alert dismissal
     logoutButtonPostHandler will be called on logout button tap and alert dismissal
     */
    func showLogoutAlert(withTitle title: String?, message: String?, cancelButtonTitle: String, logoutButtonTitle: String, cancelButtonPostHandler cancelHandler: (() -> Void)?, logoutButtonPostHandler logoutHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
            if cancelHandler != nil {
                cancelHandler!()
            }
        }
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: logoutButtonTitle, style: .destructive) { _ in
            alert.dismiss(animated: true, completion: nil)
            logoutHandler()
        }
        alert.addAction(action2)
        present(alert, animated: true)
    }
}
