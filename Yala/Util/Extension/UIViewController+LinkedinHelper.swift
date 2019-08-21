//
//  UIViewController+LinkedinHelper.swift
//  Yala
//
//  Created by Ankita on 15/10/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import UIKit
import LinkedinSwift
import SVProgressHUD

class LinkedinHelper {
    
    static let shared = LinkedinHelper()
    
    var swiftHelper = LinkedinSwiftHelper.init(configuration: LinkedinSwiftConfiguration.init(clientId: "81fxikqilidfai", clientSecret: "81fxikqilidfai", state: "DLKDJF45DIWOERCM", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://yala-ios://oauth-callback/"))
    
}

extension UIViewController {
    
    
    
    func linkedinLogin(onCompletion:((_ success: Bool)->())?) {
        let helper = LinkedinHelper.shared.swiftHelper
        helper.authorizeSuccess({[weak self] (lsToken) -> Void in
            self?.getProfile()
        }, error: { (error) -> Void in
            //Encounter error: error.localizedDescription
        }, cancel: { () -> Void in
            //User Cancelled!
        })
    }
    
    func getProfile() {
        SpinnerWrapper.showSpinner()
        let helper = LinkedinHelper.shared.swiftHelper
        helper.requestURL("https://api.linkedin.com/v1/people/~?format=json",
                                  requestType: LinkedinSwiftRequestGet,
                                  success: { [weak self] (response) -> Void in
                                    SpinnerWrapper.hideSpinnerView()
                                    print(response)
                                    let json = response.jsonObject
                                    if let fname = json?["firstName"], let lName = json?["lastName"], let id = json?["id"] {
                                        
                                    }
                                    
                                    self?.getFriends()
        }) {(error) -> Void in
            SpinnerWrapper.hideSpinnerView()
          
        }
    }
    
    func getFriends() {
        SpinnerWrapper.showSpinner()
        let helper = LinkedinHelper.shared.swiftHelper
        helper.requestURL("https://api.linkedin.com/v1/people/~/connections?format=json",
                          requestType: LinkedinSwiftRequestGet,
                          success: { (response) -> Void in
                            SpinnerWrapper.hideSpinnerView()
                            print(response)
                            let json = response.jsonObject
                            if let fname = json?["firstName"], let lName = json?["lastName"], let id = json?["id"] {
                                
                            }
        }) {(error) -> Void in
            SpinnerWrapper.hideSpinnerView()
            
        }
    }
}
