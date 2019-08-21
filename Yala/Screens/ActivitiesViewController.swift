//
//  ActivitiesViewController.swift
//  Yala
//
//  Created by Ankita on 07/12/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

class InviteCell: UITableViewCell {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var imgInviteType: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    func setupAppearance() {
        dateView.layer.cornerRadius = dateView.frame.size.height/12
        dateView.layer.shadowColor = UIColor.black.cgColor
        dateView.layer.shadowOpacity = 0.2
        dateView.layer.shadowOffset = CGSize.zero
        dateView.layer.shadowRadius = 5
    }
    
    func configureCell(_ invite: Invite) {
        let inviteDate = invite.inviteDateString?.toDate()
        if inviteDate != nil {
            yearLabel.text = DateWrapper.getYear(inviteDate!)
            monthLabel.text = DateWrapper.getMonth(inviteDate!)
            dateLabel.text = DateWrapper.getDay(inviteDate!)
            timeLabel.text = DateWrapper.getTime(inviteDate!)
        }
       
        titleLabel.text = invite.locationName
        if invite.invitingFriendName != nil, !(invite.invitingFriendName?.isEmpty)! {
            subTitleLabel.text = "By " + invite.invitingFriendName!
        }
        
        peopleLabel.text = invite.invitedFriends != nil ? "\((invite.invitedFriends?.count)! + 1)" + " Going" : "1 Going"
        
        switch invite.status {
        case "0":
            imgInviteType.image = UIImage(named: "ic_invite")
            break;
        case "1":
            imgInviteType.image = UIImage(named:"ic_accept1")
            break;
        default:
            imgInviteType.image = UIImage(named:"ic_exit1")
        }
    }
}

class ActivitiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var emptylabel: UILabel!
    
    var receivedInviteList = [Invite]()
    var sentInviteList = [Invite]()
    
    var receivedItemsPageNo = 1
    var sentItemsPageNo = 1
    var itemFetchLimit = 50
    private var spinner: UIActivityIndicatorView!

    class func fromStoryboard() -> ActivitiesViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ActivitiesViewController.self)) as! ActivitiesViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        
        navigationController?.setNavigationBarAppearance(toType: .gradient)
        setupBackButton(withAction: #selector(ActivitiesViewController.dismissMe))
        
        // after dismiss dialog
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.invitesReload), name: NSNotification.Name(rawValue: "accept_invite"), object: nil)
       
        
        setupTableView()
        setupSpinner()
        setupSegmentControl()
    }
    @objc func invitesReload(notification : NSNotification){
        print("invite here")
        receivedInviteList = []
        receivedItemsPageNo = 1
        getReceivedInvitesList()
        
        
    }
   
    
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        getReceivedInvitesList()
    }
    
    func setupSegmentControl() {
        segmentControl.addTarget(self, action: #selector(indexChanged(_:)), for:.valueChanged)
    }
    
    func setupSpinner() {
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
       // displayData()
        if segmentControl.selectedSegmentIndex == 0, receivedInviteList.count == 0 {
            getReceivedInvitesList()
        } else if segmentControl.selectedSegmentIndex == 1, sentInviteList.count == 0 {
           getSentInvitesList()
        }
    }
    
    func displayData() {
        if segmentControl.selectedSegmentIndex == 0, receivedInviteList.count == 0 {
            emptylabel.isHidden = false
            tableView.isHidden = true
        } else if segmentControl.selectedSegmentIndex == 1, sentInviteList.count == 0 {
            emptylabel.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            emptylabel.isHidden = true
        }
        tableView.reloadData()
    }
    
    func fetchMoreListData() {
        displayData()
        if segmentControl.selectedSegmentIndex == 0 {
            getReceivedInvitesList()
        } else if segmentControl.selectedSegmentIndex == 1 {
            getSentInvitesList()
        }
    }
    
    func getReceivedInvitesList() {
        displayData()
        emptylabel.isHidden = true
        if receivedItemsPageNo == 1 {
            tableView.tableFooterView = UIView()
            tableView.tableFooterView?.isHidden = true
            SpinnerWrapper.showSpinner()
        } else {
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
        }
        APIManager.shared.request(InviteAPIRequest.init(requestType: InviteAPIRequestEndpoint.receivedInites(receivedItemsPageNo))) { [weak self] (success, response: InviteListResponse?, _, _, error) in
            SpinnerWrapper.hideSpinnerView()
            self?.tableView.tableFooterView = UIView()
            self?.tableView.tableFooterView?.isHidden = true
            if response != nil, response?.data != nil {
                self?.receivedInviteList.append(contentsOf: response?.data as! [Invite])
                self?.receivedItemsPageNo += 1
            } else if response != nil, response?.result != nil {
                self?.receivedInviteList.append(contentsOf: response?.result as! [Invite])
                self?.receivedItemsPageNo += 1
            }
            self?.displayData()
            
         //   self!.tableView.reloadData()
        }
        
    }
    
    func getSentInvitesList() {
        displayData()
        emptylabel.isHidden = true
        
        if sentItemsPageNo == 1 {
            tableView.tableFooterView = UIView()
            tableView.tableFooterView?.isHidden = true
            SpinnerWrapper.showSpinner()
        } else {
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
        }
        APIManager.shared.request(InviteAPIRequest.init(requestType: InviteAPIRequestEndpoint.sentInvites(sentItemsPageNo))) { [weak self] (success, response: InviteListResponse?, _, _, error) in
            
            SpinnerWrapper.hideSpinnerView()
            self?.tableView.tableFooterView = UIView()
            self?.tableView.tableFooterView?.isHidden = true
            
            if response != nil, response?.data != nil { 
                self?.sentInviteList.append(contentsOf: response?.data as! [Invite])
                self?.sentItemsPageNo += 1
            }
            
            self?.displayData()
            
            self!.tableView.reloadData()
        }
    }
    
    @objc func dismissMe() {
         self.dismiss(animated: true, completion: nil)
    }
    
}

extension ActivitiesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return receivedInviteList.count
        case 1:
            return sentInviteList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell") as! InviteCell
        
        var invite = Invite()
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            invite = receivedInviteList[indexPath.row]
        case 1:
            invite = sentInviteList[indexPath.row]
        default:
            break
        }
        
        cell.configureCell(invite)
        
        return cell
    }
}

extension ActivitiesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = InviteDetailViewController.fromStoryboard()
        let vc = InvitePopUpViewController.fromStoryboard()
        switch segmentControl.selectedSegmentIndex {
        case 0:
            vc.invite = receivedInviteList[indexPath.row]
            vc.invite.isCreatedByMe = false
            break
        case 1:
            vc.invite = sentInviteList[indexPath.row]
            vc.invite.isCreatedByMe = true
        default:
            break
        }
        
        if(vc.invite.status == "0"){
            navigationController?.pushViewController(vc, animated: true)
//            present(vc , animated: true)
        }
        
    }
}
