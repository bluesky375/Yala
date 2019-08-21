//
//  AppDelegate.swift
//  Yala
//
//  Created by Ankita ( yala.com ) on 01/08/18.
//  Copyright © 2018 Yala. All rights reserved.

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import FirebaseMessaging
import UserNotifications
import LinkedinSwift
import Quickblox
import IQKeyboardManagerSwift

let kQBApplicationID:UInt = 75024
let kQBAuthKey = "zyWONeYpyAVVr4B"
let kQBAuthSecret = "DrNK-JDqThWfYHK"
let kQBAccountKey = "NJPLYJeMRV5sgoCaoKKX"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pushToken: String?
    weak var homeTabVC: HomeTabViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        FirebaseApp.configure()
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        MapsServiceManager.registerGoogleMapsServices()
        setupNavigationBarAttributes()
        
        setupRootScreen(defaultSelectedTabIndex: 0)
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        application.applicationIconBadgeNumber = 0
        
        // Set QuickBlox credentials (You must create application in admin.quickblox.com).
        QBSettings.applicationID = kQBApplicationID;
        QBSettings.authKey = kQBAuthKey
        QBSettings.authSecret = kQBAuthSecret
        QBSettings.accountKey = kQBAccountKey
        // enabling carbons for chat
        QBSettings.carbonsEnabled = true
        // Enables Quickblox REST API calls debug console output.
        QBSettings.logLevel = .debug
        
        // Enables detailed XMPP logging in console output.
        QBSettings.enableXMPPLogging()
        
        // app was launched from push notification, handling it
        let remoteNotification: NSDictionary! = launchOptions?[.remoteNotification] as? NSDictionary
        if (remoteNotification != nil) {
            ServicesManager.instance().notificationService.pushDialogID = remoteNotification["SA_STR_PUSH_NOTIFICATION_DIALOG_ID".localized] as? String
        }
        
        
        return true
    }
    
    func setupNavigationBarAttributes() {
        let navigationBarAppearace = UINavigationBar.appearance()
        //navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearace.shadowImage = UIImage()
        
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.systemFont(ofSize: 12)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.systemFont(ofSize: 12)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        // Logging out from chat.
        ServicesManager.instance().chatService.disconnect(completionBlock: nil)

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Logging in to chat.
        ServicesManager.instance().chatService.connect(completionBlock: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Logging out from chat.
        ServicesManager.instance().chatService.disconnect(completionBlock: nil)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled = SDKApplicationDelegate.shared.application(app, open: url, options: options)
    
        if LinkedinSwiftHelper.shouldHandle(url) {
            handled = LinkedinSwiftHelper.application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        }

        return handled
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo)
        
        print("my push is: %@", userInfo)
        guard application.applicationState == UIApplicationState.inactive else {
            return
        }
        
        guard let dialogID = userInfo["SA_STR_PUSH_NOTIFICATION_DIALOG_ID".localized] as? String else {
            return
        }
        
        guard !dialogID.isEmpty else {
            return
        }
        
        
        let dialogWithIDWasEntered: String? = ServicesManager.instance().currentDialogID
        if dialogWithIDWasEntered == dialogID {
            return
        }
        
        ServicesManager.instance().notificationService.pushDialogID = dialogID
        
        // calling dispatch async for push notification handling to have priority in main queue
        DispatchQueue.main.async {
            
            ServicesManager.instance().notificationService.handlePushNotificationWithDelegate(delegate: self)
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
        
        let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
        let subscription = QBMSubscription()
        
        subscription.notificationChannel = .APNS
        subscription.deviceUDID = deviceIdentifier
        subscription.deviceToken = deviceToken
        QBRequest.createSubscription(subscription, successBlock: { (response: QBResponse!, objects: [QBMSubscription]?) -> Void in
            
        }) { (response: QBResponse!) -> Void in
            
        }
    }
    
    func setupRootScreen(defaultSelectedTabIndex: Int) {
        let hasRunBefore = UserDefaultsWrapper.shared.retrieveValue(forKey: "hasRunBefore") as? Bool
        print("here!",UserAccountManager.shared.getAuthorisationToken())
        let user = User.loadCurrentUser()
        if (hasRunBefore==true) && (user != nil) {
            RootViewControllerFactory.shared.configureRootViewController(forType: .home(0), window: self.window!, animated: false)
        }else if(hasRunBefore == true){
            RootViewControllerFactory.shared.configureRootViewController(forType: .landing, window: self.window!, animated: true)
        }else{
            RootViewControllerFactory.shared.configureRootViewController(forType: .onboarding, window: self.window!, animated: true)
            
        }
        
        UserDefaultsWrapper.shared.save(value: true, forKey: "hasRunBefore")
    }
}

@available(iOS 10, *)

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests) in
            
            for request in requests {
                
                if request.identifier == "IDENTIFIER YOU'RE CHECKING IF EXISTS" {
                    
                    //Notification already exists. Do stuff.
                    
                } else if request === requests.last {
                    
                    //All requests have already been checked and notification with identifier wasn't found. Do stuff.
                    
                }
            }
        })
        
        ListenerDispatcher.shared.fire(event: NotificationReceived())
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo)
        completionHandler([.alert,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        
        setupRootScreen(defaultSelectedTabIndex: 3)

        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        pushToken = fcmToken
        
        if User.loadCurrentUser() != nil {
            //UserService.shared.updateToken(completionHandler: nil)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}


extension AppDelegate: NotificationServiceDelegate {
    // MARK: NotificationServiceDelegate protocol
    
    func notificationServiceDidStartLoadingDialogFromServer() {
    }
    
    func notificationServiceDidFinishLoadingDialogFromServer() {
    }
    
    func notificationServiceDidSucceedFetchingDialog(chatDialog: QBChatDialog!) {
        let navigatonController: UINavigationController! = self.window?.rootViewController as? UINavigationController
        
        let chatController: ChatViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatController.dialog = chatDialog
        
        let dialogWithIDWasEntered = ServicesManager.instance().currentDialogID
        if !dialogWithIDWasEntered.isEmpty {
            // some chat already opened, return to dialogs view controller first
            navigatonController.popViewController(animated: false);
        }
        
        navigatonController.pushViewController(chatController, animated: true)
    }
    
    func notificationServiceDidFailFetchingDialog() {
    }
}
