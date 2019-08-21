//
//  LandingViewController.swift
//  Yala
//
//  Created by Ankita on 07/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import SVProgressHUD

class LandingViewController: UIViewController {
    
    @IBOutlet private weak var signInWithFacebookButton: UIButton!
    @IBOutlet private weak var emailSignInButton: UIButton!
    @IBOutlet private weak var signupButton: UIButton!

    class func fromStoryboard() -> LandingViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: LandingViewController.self)) as! LandingViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
