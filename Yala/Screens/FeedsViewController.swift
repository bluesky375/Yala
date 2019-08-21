//
//  FeedsViewController.swift
//  Yala
//
//  Created by Admin on 3/29/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import SVProgressHUD
import BEMCheckBox
import Kingfisher
import EMSpinnerButton
import MessageUI
import CoreLocation
import Messages

class FeedsViewController: UIViewController, VisibleTabBarProtocol {
    
    var user: User!
    var friends : [Friend] = []
    var feedbacks : [FeedItem] = []
    var cellType: FriendCellType = .invite

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        user = User.loadCurrentUser()
    //    getFriendList()
        getFeedbacks()
        
    }
    
    class func fromStoryboard() -> FeedsViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: FeedsViewController.self)) as! FeedsViewController
        return viewController
    }
    
    
    func getFeedbacks(){
        SpinnerWrapper.showSpinner()
        UserService.shared.getFeedbacks(user) { [weak self] (success, error, feedbacks) in
            SpinnerWrapper.hideSpinnerView()
            if feedbacks != nil, (feedbacks?.count)! > 0 {
                self?.feedbacks = feedbacks!
                self?.tableView.reloadData()
            } else {
                print("There is no feedbacks!")
            }
        }
        
    }
    
    @objc func addLike(button : UIButton){
       // print("button clicked! \(button.tag)")
        let eventId = feedbacks[button.tag].id
        UserService.shared.addLikeToEvent(eventId!) { [weak self] (success, error, feedbacks) in
            if feedbacks != nil, (feedbacks?.count)! > 0 {
                self?.feedbacks = feedbacks!
                self?.tableView.reloadData()
            } else {
                print("There is no feedbacks!")
            }
        }
    }
    @objc func addComment(button : UIButton){
        let selectEvent = feedbacks[button.tag]
        let vc = storyboard?.instantiateViewController(withIdentifier: "CommetLeaveViewController") as! CommetLeaveViewController
        vc.feedback = selectEvent
        present(vc,animated: true, completion: nil)
        
    }

}


extension FeedsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItemTableViewCell") as! FeedItemTableViewCell
        let feeditem = feedbacks[indexPath.item]
        cell.configure(feeditem)
        cell.btnLikeToEvent?.addTarget(self, action: #selector(self.addLike), for: .touchUpInside)
        cell.btnLikeToEvent.tag = indexPath.item
        
        cell.btnAddComment?.addTarget(self, action: #selector(self.addComment), for: .touchUpInside)
        cell.btnAddComment.tag = indexPath.item
        
        return cell
    }
}


extension FeedsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
