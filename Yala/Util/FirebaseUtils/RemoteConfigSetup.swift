//
//  RemoteConfigSetup.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Firebase
import StoreKit
import FirebaseRemoteConfig

/**
    This class is responsible for displaying application update dialog when a new version is published to app store with the help of Firebase Remote Config feature
 
    Prerequesitics:
        1. Create app in firebase
        2. install google info plist
        3. setup remote config with following keys and their default value
            a. app_force_update_required_iOS :- if true udpate dialog with only Update button will be shown in app, if false then update dialog with Cancel and Update button will be shown
            b. app_current_version_iOS : Current version of the app on app store
            c. app_store_url_iOS : App url from itunes connect
 
    Customisation:
        1. appStoreURL property provides application app store url
 */

let kfireBaseForceUpdate = "app_force_update_required_iOS"
let kfireBaseAppVersion = "app_current_version_iOS"
let kfireBaseAppstoreURL = "app_store_url_iOS"

class RemoteConfigSetup {
    
    weak var previousWindow: UIWindow?
    
    var isUpdateDialogShown = false
    var remoteConfig: RemoteConfig!
    var currentAppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    var appStoreURL = "https://itunes.apple.com/us/app/myproject/id1358062351?ls=1&mt=8"
    
    static let shared = RemoteConfigSetup()
    
    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let remoteConfiDefaults = [kfireBaseForceUpdate: "false",
                                   kfireBaseAppVersion : currentAppVersion,
                                   kfireBaseAppstoreURL : appStoreURL]
        remoteConfig?.setDefaults(remoteConfiDefaults as? [String : NSObject])
    }
    
    func configure() {
        let fetchDuration: TimeInterval = 43_200
        remoteConfig.fetch(withExpirationDuration: fetchDuration) {[weak self] status, _ in
            if status == .success {
                self?.remoteConfig?.activateFetched()
                let appVersion = self?.remoteConfig![kfireBaseAppVersion].stringValue
                if appVersion != self?.currentAppVersion && self?.isUpdateDialogShown == false {
                    self?.showUpdateDialog()
                }
            }
        }
    }
    
    func showUpdateDialog() {
        let shouldShowForceUpdate = remoteConfig![kfireBaseForceUpdate].boolValue
        if shouldShowForceUpdate == true {
            showForceUpdateDialog()
        } else {
            showAppUpdateDialogWithCancel()
        }
        
        isUpdateDialogShown = true
    }
    
    func showForceUpdateDialog() {
        let window = alertWindow()
        window.rootViewController?.showAlert(withTitle: "App update available",
                                             message: "A new version of 'Yala' is available. Please update now.",
                                             buttonTitle: "Update",
                                             shouldDismissOnButtonTap: false,
                                             buttonTapHandler: { [weak self] in
                                                let appURL = self?.remoteConfig![kfireBaseAppstoreURL].stringValue
                                                UIViewController().open(url: URL.init(string: appURL!)!)
        })
    }
    
    func showAppUpdateDialogWithCancel() {
        previousWindow = UIApplication.shared.keyWindow
        
        let window = alertWindow()
        window.rootViewController?.showAlert(withTitle: "App update available",
                                             message: "A new version of 'Yala' is available. Please update now.",
                                             cancelButtonTitle: "Later",
                                             otherButtonTitle: "Update", cancelButtonPostHandler: { [weak self] in
            self?.previousWindow?.makeKeyAndVisible()
            window.isHidden = true
        }, otherButtonPostHandler: { [weak self] in
            self?.previousWindow?.makeKeyAndVisible()
            window.isHidden = true
            let appURL = self?.remoteConfig![kfireBaseAppstoreURL].stringValue
            UIViewController().open(url: URL.init(string: appURL!)!)
        })
    }
    
    func activateDebugMode() {
        let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = debugSettings
    }
    
    func alertWindow() -> UIWindow {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 2
        alertWindow.makeKeyAndVisible()
        return alertWindow
    }
}
