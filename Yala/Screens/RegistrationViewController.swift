//
//  RegistrationViewController.swift
//  Yala
//
//  Created by Ankita on 07/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import SVProgressHUD
import Quickblox

class RegistrationViewController: UIViewController {

    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var signupButton: ActivityButton!
    
    class func fromStoryboard() -> RegistrationViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: RegistrationViewController.self)) as! RegistrationViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }

    func setupAppearance() {
        signupButton.title = "SIGN UP"
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
        view.endEditing(true)
        
        guard validateAllFields() else {
            return
        }
        
        let user = User()
        user.username = emailTextField.text?.trim()
        user.firstName = firstNameTextField.text?.trim()
        user.lastName = lastNameTextField.text?.trim()
        user.email = emailTextField.text?.trim()
        
        if phoneTextField.text != nil {
            user.mobile = phoneTextField.text?.trim()
        }
        
        user.password = passwordTextField.text
        
        view.isUserInteractionEnabled = false
        signupButton.animate(animation: .collapse)
        
        APIManager.shared.request(RegisterAPIRequest.init(requestType: RegisterEndpoint.emailRegistration(user))) {[weak self] (success, response1: GenericResponse?, _, anyJson, error) in
            
            if response1?.error == false {
                let qbUser = QBUUser()
                qbUser.login = user.email
                qbUser.password = user.password
                qbUser.email = user.email
                qbUser.fullName = user.displayName()
                
                ServicesManager.instance().authService.signUpAndLogin(with: qbUser) { (response, user) in
                    self?.signupButton.animate(animation: .expand)
                    self?.view.isUserInteractionEnabled = true
                    
                    self?.showAlert(withTitle: "", message: response1?.message, postDismisshandler: {
                        let vc = LoginViewController.fromStoryboard()
                        self?.view.window?.rootViewController = vc
                    })
                }
            } else if response1?.message != nil {
                self?.signupButton.animate(animation: .expand)
                self?.view.isUserInteractionEnabled = true
                
                self?.showAlert(withTitle: "", message: response1?.message)
            } else {
                self?.signupButton.animate(animation: .expand)
                self?.view.isUserInteractionEnabled = true
                
                self?.showAlert(withTitle: "", message: "Something went wrong, please try again later.")
            }
        }
    }
    
    @IBAction func signinFacebookAction() {
        signInWithFacebook { [weak self] (success, error) in
            SpinnerWrapper.hideSpinnerView()
            if success {
               RootViewControllerFactory.shared.configureRootViewController(forType: .home(0), window: (self?.view.window)!, animated: true)
            } else  {
                self?.showAlert(withTitle: "", message: "Some error occured in sign in, please try again.")
            }
        }
    }
}

extension RegistrationViewController {
    
    func validateAllFields() -> Bool {
        let firstname = firstNameTextField.text?.trim()
        let lastnam = lastNameTextField.text?.trim()
        let email = emailTextField.text?.trim()

        if (firstname != nil), (firstname?.count)! <= 0 {
            showAlert(withTitle: "", message: "Please provide your first name")
            return false
        } else if (lastnam != nil), (lastnam?.count)! <= 0 {
            showAlert(withTitle: "", message: "Please provide your last name")
            return false
        } else if (email != nil), (email?.count)! <= 0 {
            showAlert(withTitle: "", message: "Please provide your email")
            return false
        } else if Validations.isValidEmail(email!) == false {
            showAlert(withTitle: "", message: "Please provide valid email")
            return false
        } else if passwordTextField.text != nil, passwordTextField.text?.isEmpty == true {
            showAlert(withTitle: "", message: "Please provide a password")
            return false
        } else if confirmPasswordTextField.text != nil, confirmPasswordTextField.text?.isEmpty == true {
            showAlert(withTitle: "", message: "Please confirm the entered password")
            return false
        } else if passwordTextField.text != confirmPasswordTextField.text {
            showAlert(withTitle: "", message: "Password and confirm password didn't match")
            return false
        } else {
            return true
        }
    }
}
