//
//  NotificationViewController.swift
//  Yala
//
//  Created by Ankita on 10/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import Kingfisher

class NotificationCell: UITableViewCell {
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    func configureCell(_ notification: YalaNotification) {
        label.text = notification.message
    
        let date1 = DateWrapper.UTCToLocal(date: notification.senddate!)
        let date = date1.toDate()

        if date != nil {
            timeAgoLabel.text = DateWrapper.timeAgo(fromDate: date1.toDate()!)
        } else {
            timeAgoLabel.text = ""
        }
        
        if let photoURL = notification.profileImage {
            profileImage.kf.setImage(with: URL(string: photoURL), placeholder: UIImage(named: "empty_profile_icon"), options: [.cacheOriginalImage])
        } else {
            profileImage.image = UIImage.init(named: "empty_profile_icon")
        }
        
        if notification.isNotificationRead() {
            label.textColor = UIColor.lightGray
        } else {
            label.textColor = UIColor.darkGray
        }
    }
    
    func markAsRead() {
        label.textColor = UIColor.lightGray
    }
}

class NotificationViewController: UIViewController, VisibleTabBarProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var user: User!
    var notifications = [YalaNotification]()
    
    var notificationItemsPageNo = 1
    var itemFetchLimit = 100
    
    var refreshControl: UIRefreshControl!
    
    private var spinner: UIActivityIndicatorView!
    
    class func fromStoryboard() -> NotificationViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: NotificationViewController.self)) as! NotificationViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       navigationController?.isNavigationBarHidden = true
        
        setLeftHamburgerButtonToShowMenu(withImage: (UIImage.init(named: "menu_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))!)
        
        setupTableView()
        setupSpinner()
        
        ListenerDispatcher.shared.addListener(self, eventType: NotificationReceived.self, OperationQueue.main)
        
        user = User.loadCurrentUser()
        fetchNotifications(true)
    }
    
    func setupTableView() {
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func setupSpinner() {
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
    }
    
    @objc func refresh(_ sender: Any) {
        notificationItemsPageNo = 1
        fetchNotifications(false)
    }
    
    func fetchNotifications(_ showSpinner: Bool) {
        if showSpinner {
            if notificationItemsPageNo == 1 {
                tableView.tableFooterView = UIView()
                tableView.tableFooterView?.isHidden = true
                SpinnerWrapper.showSpinner()
            } else {
                tableView.tableFooterView = spinner
                tableView.tableFooterView?.isHidden = false
            }
        }
        
        APIManager.shared.request(GETNotificationsAPIRequests.init(requestType: GETNotificationsAPIEndpoint.fetch(notificationItemsPageNo))) { [weak self] (success, response: YalaNotificationResponse?, _, _, error) in
            SpinnerWrapper.hideSpinnerView()
            self?.tableView.tableFooterView = UIView()
            
            if response != nil, response?.result != nil, (response?.result!.count)! > 0 {
                if self?.refreshControl.isRefreshing == true {
                    self?.notifications = (response?.result!)!
                } else {
                    self?.notifications.append(contentsOf: response?.result as! [YalaNotification])
                }
                
                self?.notificationItemsPageNo += 1
                self?.tableView.reloadData()
                self?.emptyLabel.isHidden = true
            } else if response?.message != nil {
                self?.emptyLabel.isHidden = false
                self?.showAlert(withTitle: "", message: response?.message)
            } else {
                self?.emptyLabel.isHidden = false
                self?.showAlert(withTitle: "", message: "Something went wrong, please try again later.")
            }
            self?.refreshControl.endRefreshing()
        }
    }
}

extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        let notification = notifications[indexPath.row]
        
        cell.configureCell(notification)
        
        return cell
    }
}

extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath) as? NotificationCell
        
        if notification.isNotificationCreateInviteType() {
            let vc = ActivityConfirmationViewController.fromStoryboard()
            vc.notification = notification
            let navigationController = UINavigationController.init(rootViewController: vc)
            vc.backButtonAction = {
                navigationController.dismiss(animated: true, completion: nil)
            }
          
            present(navigationController, animated: true, completion: nil)
        }
        
        APIManager.shared.request(MarkNotificationAsReadAPIRequests.init(requestType: MarkNotificationAsReadAPIEndPoint.markAsRead([notification.id!]))) { (success, response: GenericResponse?, _, _, _) in
            cell?.markAsRead()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && (indexPath.row >= itemFetchLimit - 1 ) {
            fetchNotifications(true)
        }
    }
}

//  MARK:- ListenerDispatcherProtocol methods

extension NotificationViewController: ListenerDispatcherProtocol {
    
    func didFireEventWithDispatcher(_ dispatcher: ListenerDispatcher, withEvent event: AnyObject) {
        if type(of: event) === NotificationReceived.self {
            user = User.loadCurrentUser()
            refresh(event)
        }
    }
}
