//
//  CommetLeaveViewController.swift
//  Yala
//
//  Created by Admin on 3/30/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit

class CommetLeaveViewController: UIViewController {

    
    var feedback : FeedItem = FeedItem.init()
    var commentList : [CommentItem] = []
    
    @IBOutlet weak var imgFeedBack: UIImageView!
    @IBOutlet weak var lblEventType: UILabel!
    @IBOutlet weak var lblFeedName: UILabel!
    @IBOutlet weak var tblCommentList: UITableView!
    @IBOutlet weak var txtComment: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configView()
    }
    func configView(){
        lblFeedName.text = feedback.displayName()
        lblEventType.text = feedback.location
        
        if feedback.profileimage != nil && feedback.profileimage != "" {
            imgFeedBack.kf.setImage(with: URL(string: feedback.profileimage!), placeholder: UIImage(named: "ic_profile"), options: [.cacheOriginalImage])
        } else {
            imgFeedBack.image = UIImage.init(named: "ic_profile")
        }
        onAddComment((Any).self)
        tblCommentList.separatorStyle = .none
        tblCommentList.estimatedRowHeight = 100
        tblCommentList.rowHeight = UITableViewAutomaticDimension
    }
    @IBAction func onAddComment(_ sender: Any) {
        let eventId = feedback.id
        let comment = txtComment.text
        UserService.shared.addCommentToEvent(eventId!, comment!
        ) { [weak self] (success, error, commentList) in
            if commentList != nil, (commentList?.count)! > 0 {
                self?.commentList = commentList!
                self?.tblCommentList.reloadData()
                self?.txtComment.text = ""
            } else {
                print("There is no comment data!")
            }
        }
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension CommetLeaveViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentItemTableViewCell") as! CommentItemTableViewCell
        let commentItem = commentList[indexPath.item]
        cell.commentItem = commentItem
        cell.configView()
        
        
        return cell
    }
}


extension CommetLeaveViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
