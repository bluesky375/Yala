//
//  ViewController.swift
//  Yala
//
//  Created by Ankita ( yala.com ) on 01/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signinButton: ActivityButton!
    
    class func fromStoryboard() -> LoginViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
    }
    
    func setupAppearance() {
        signinButton.title = "SIGN IN"
    }
    
    @IBAction func signInAction(_ sender: Any) {
        view.endEditing(true)
        
        guard validateAllFields() else {
            return
        }
        
        view.isUserInteractionEnabled = false
        signinButton.animate(animation: .collapse)
        
        APIManager.shared.request(OAuthAPIRequest.init(requestType: OAuthRequestType.loginUser((emailTextField.text?.trim())!, (passwordTextField.text?.trim())!))) { [weak self] (success, user: User?, _, _, error) in
            
            self?.signinButton.animate(animation: .expand)
            self?.view.isUserInteractionEnabled = true
            
            if user?.token != nil {
                
                let credentials = OAuthCredentials.init()
                credentials.accessToken = user?.token
                UserAccountManager.shared.saveCredentials(credentials)
                User.saveUser(user: user!)
                RootViewControllerFactory.shared.configureRootViewController(forType: .home(0), window: (self?.view.window)!, animated: true)
                
            } else if user?.message != nil {
                 self?.showAlert(withTitle: "", message: user?.message)
            } else if error != nil {
                self?.showError(error!)
            } else {
                self?.showAlert(withTitle: "", message: "Please check your credentials and try again.")
            }
        }
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc = ForgotPasswordViewController.fromStoryboard()
        let navigationController = UINavigationController.init(rootViewController: vc)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func facebookSignInAction(_ sender: Any) {
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

extension LoginViewController {
    
    func validateAllFields() -> Bool {
        let email = emailTextField.text?.trim()
        let password = passwordTextField.text?.trim()
        
        if email != nil, (email?.count)! <= 0 {
            showAlert(withTitle: "", message: "Please provide your email")
            return false
        } else if password != nil, (password?.count)! <= 0 {
            showAlert(withTitle: "", message: "Please provide your password")
            return false
        } else {
            return true
        }
    }
}
