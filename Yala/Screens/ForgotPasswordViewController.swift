//
//  ForgotPasswordViewController.swift
//  Yala
//
//  Created by Ankita on 20/12/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

enum ForgotPassViewDisplayType {
    case forgotPass, updatePass
}

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var otpTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var submitButton: ActivityButton!
    
    @IBOutlet private weak var submitButtonTOPCOnstraint: NSLayoutConstraint!

    var viewType = ForgotPassViewDisplayType.forgotPass
    
    class func fromStoryboard() -> ForgotPasswordViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ForgotPasswordViewController.self)) as! ForgotPasswordViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarAppearance(toType: .white)
        title = "Forgot Password"
        submitButton.title = "SUBMIT"
        setupBarButtons()
        
        updateViewDisplay()
    }
    
    func setupBarButtons() {
        let leftButton = UIBarButtonItem.init(image: UIImage.init(named: "downArrow"), style: .plain, target: self, action: #selector(dismissMe))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    func updateViewDisplay() {
        if viewType == .forgotPass {
            passwordTextField.isHidden = true
            otpTextField.isHidden = true
            submitButtonTOPCOnstraint.constant = 40
        } else if viewType == .updatePass {
            passwordTextField.isHidden = false
            otpTextField.isHidden = false
            submitButtonTOPCOnstraint.constant = 180
        }
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        view.endEditing(true)
        
        if viewType == .forgotPass {
            forgotPasswordAction()
        } else if viewType == .updatePass {
            updatePasswordAction()
        }
    }
    
    func forgotPasswordAction() {
        guard emailTextField.text != nil else {
             showAlert(withTitle: "Please provide email id", message: nil)
            return
        }
        
        view.isUserInteractionEnabled = false
        submitButton.animate(animation: .collapse)
        
        APIManager.shared.request(ForgotPasswordAPIRequest.init(requestType: ForgotPasswordAPIEndPoint.forgotPassword(emailTextField.text!))) { [weak self] (success, response: GenericResponse?, _, _, error) in
            self?.submitButton.animate(animation: .expand)
            self?.view.isUserInteractionEnabled = true
            
            if response?.error == false {
                self?.viewType = ForgotPassViewDisplayType.updatePass
                self?.updateViewDisplay()
            }
            
            self?.showAlert(withTitle: response?.message, message: nil)
        }
    }
    
    func updatePasswordAction() {
        guard emailTextField.text != nil, otpTextField.text != nil, passwordTextField.text != nil else {
            showAlert(withTitle: "Please provide all fields", message: nil)
            return
        }
        
        view.isUserInteractionEnabled = false
        submitButton.animate(animation: .collapse)
        
        APIManager.shared.request(ForgotPasswordAPIRequest.init(requestType: ForgotPasswordAPIEndPoint.updatePassword(emailTextField.text!, otpTextField.text!, passwordTextField.text!))) { [weak self] (success, response: GenericResponse?, _, _, error) in
            self?.submitButton.animate(animation: .expand)
            self?.view.isUserInteractionEnabled = true
            
            if response?.error == false {
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }
            self?.showAlert(withTitle: response?.message, message: nil)
        }
    }
    
    @objc func dismissMe() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
