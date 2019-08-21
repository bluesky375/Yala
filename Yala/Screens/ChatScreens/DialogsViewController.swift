//
//  DialogsTableViewController.swift
//  sample-chat-swift
//
//  Created by Anton Sokolchenko on 4/1/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

import UIKit

class DialogTableViewCellModel: NSObject {
    
    var detailTextLabelText: String = ""
    var textLabelText: String = ""
    var unreadMessagesCounterLabelText : String?
    var unreadMessagesCounterHiden = true
    var dialogIcon : UIImage?

    
    init(dialog: QBChatDialog) {
        super.init()
		
		switch (dialog.type){
		case .publicGroup:
			self.detailTextLabelText = "SA_STR_PUBLIC_GROUP".localized
		case .group:
			self.detailTextLabelText = "SA_STR_GROUP".localized
		case .private:
			self.detailTextLabelText = "SA_STR_PRIVATE".localized
			
			if dialog.recipientID == -1 {
				return
			}
			
			// Getting recipient from users service.
			if let recipient = ServicesManager.instance().usersService.usersMemoryStorage.user(withID: UInt(dialog.recipientID)) {
                if recipient.fullName != nil {
                    self.textLabelText = recipient.fullName!
                } else if recipient.email != nil {
                    self.textLabelText = recipient.email!
                } else if recipient.login != nil {
                    self.textLabelText = recipient.login!
                } else {
                    self.textLabelText = ""
                }
			}
		}
        
        if self.textLabelText.isEmpty {
            // group chat
            
            if let dialogName = dialog.name {
                self.textLabelText = dialogName
            }
        }
        
        // Unread messages counter label
        
        if (dialog.unreadMessagesCount > 0) {
            
            var trimmedUnreadMessageCount : String
            
            if dialog.unreadMessagesCount > 99 {
                trimmedUnreadMessageCount = "99+"
            } else {
                trimmedUnreadMessageCount = String(format: "%d", dialog.unreadMessagesCount)
            }
            
            self.unreadMessagesCounterLabelText = trimmedUnreadMessageCount
            self.unreadMessagesCounterHiden = false
            
        }
        else {
            
            self.unreadMessagesCounterLabelText = nil
            self.unreadMessagesCounterHiden = true
        }
        
        // Dialog icon
        
        if dialog.type == .private {
            self.dialogIcon = UIImage(named: "user")
        }
        else {
            self.dialogIcon = UIImage(named: "GroupChatIcon")
        }
    }
}

class DialogsViewController: UITableViewController, QMChatServiceDelegate, QMChatConnectionDelegate, QMAuthServiceDelegate, VisibleTabBarProtocol {
    
    class func fromStoryboard() -> DialogsViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: DialogsViewController.self)) as! DialogsViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.title = "Messages"
        navigationController?.setNavigationBarAppearance(toType: .gradient)
        
//        setLeftHamburgerButtonToShowMenu(withImage: (UIImage.init(named: "menu_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))!)
        
//
        ServicesManager.instance().chatService.addDelegate(self)
        ServicesManager.instance().authService.add(self)
       
        if (QBChat.instance.isConnected) {
             self.getDialogs()
        } else {
            connectChatandFetchDialogs()
        }
        
        let barButton = UIBarButtonItem.init(title: "New Chat", style: .plain, target: self, action: #selector(openNewDialofVC))
        barButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [barButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func openNewDialofVC() {
        let newVC = NewDialogViewController.fromStoryboard()
        let navCnt = UINavigationController.init(rootViewController: newVC)
        present(navCnt, animated: true, completion: nil)
    }
    
    func connectChatandFetchDialogs() {
        let user = User.loadCurrentUser()
        
        let qbUser = QBUUser()
        qbUser.login = user!.email
        qbUser.password = user!.email
        qbUser.email = user!.email
        qbUser.fullName = user?.displayName()
        
        let enviroment = Constants.QB_USERS_ENVIROMENT
        qbUser.tags = [enviroment]
        
        SpinnerWrapper.showSpinner()
        ServicesManager.instance().authService.logIn(with: qbUser, completion: { (response, user) in
            let userId = user?.id != nil ? (user?.id)! : 0
            
            ServicesManager.instance().chatService.connect(completionBlock: { [weak self] (error) in
                SpinnerWrapper.hideSpinnerView()
                self?.getDialogs()
            })
            
            APIManager.shared.request(PostChatIDAPIRequest.init(requestType: PostChatIDEndpoint.sentId(Int(userId))), completionHandler: { (success, response: GenericResponse?, _, _, error) in
                
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatVC = segue.destination as? ChatViewController {
            chatVC.dialog = sender as? QBChatDialog
        }
    }
	
    // MARK: - DataSource Action
	
    func getDialogs() {
        if let lastActivityDate = ServicesManager.instance().lastActivityDate {
			ServicesManager.instance().chatService.fetchDialogsUpdated(from: lastActivityDate as Date, andPageLimit: kDialogsPageLimit, iterationBlock: { (response, dialogObjects, dialogsUsersIDs, stop) -> Void in
				
				}, completionBlock: { [weak self] (response) -> Void in
                    if (response.isSuccess) {
                        ServicesManager.instance().lastActivityDate = NSDate()
                        self?.reloadTableViewIfNeeded()
                    }
			})
        }
        else {
            SpinnerWrapper.showSpinner()
            
			ServicesManager.instance().chatService.allDialogs(withPageLimit: kDialogsPageLimit, extendedRequest: nil, iterationBlock: { (response: QBResponse?, dialogObjects: [QBChatDialog]?, dialogsUsersIDS: Set<NSNumber>?, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
				
				}, completion: { [weak self] (response: QBResponse?) -> Void in
					SpinnerWrapper.hideSpinnerView()
					guard response != nil && response!.isSuccess else {
						self?.showAlert(withTitle: "Failed to load chat threads.", message: "Please try again later.")
						return
					}
					ServicesManager.instance().lastActivityDate = NSDate()
                    self?.reloadTableViewIfNeeded()
			})
        }
    }

    // MARK: - DataSource
    
	func dialogs() -> [QBChatDialog]? {
        return ServicesManager.instance().chatService.dialogsMemoryStorage.dialogsSortByUpdatedAt(withAscending: false)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let dialogs = self.dialogs() {
			return dialogs.count
		}
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogcell", for: indexPath) as! DialogTableViewCell
        
        if ((self.dialogs()?.count)! < indexPath.row) {
            return cell
        }
        
        guard let chatDialog = self.dialogs()?[indexPath.row] else {
            return cell
        }
        
        cell.isExclusiveTouch = true
        cell.contentView.isExclusiveTouch = true
        
        cell.tag = indexPath.row
        cell.dialogID = chatDialog.id!
        
        let cellModel = DialogTableViewCellModel(dialog: chatDialog)
        
        cell.dialogLastMessage?.text = chatDialog.lastMessageText
        cell.dialogName?.text = cellModel.textLabelText
        cell.dialogTypeImage.image = cellModel.dialogIcon
        cell.unreadMessageCounterLabel.text = cellModel.unreadMessagesCounterLabelText
        cell.unreadMessageCounterHolder.isHidden = cellModel.unreadMessagesCounterHiden
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let dialog = self.dialogs()?[indexPath.row] else {
            return
        }
        
        let chat = ChatViewController.fromStoryboard()
        chat.dialog = dialog
        let navController = UINavigationController.init(rootViewController: chat)
        present(navController, animated: true, completion: nil)
        //self.performSegue(withIdentifier: "goToChat" , sender: dialog)
    }
    
    // MARK: - QMChatServiceDelegate
	
    func chatService(_ chatService: QMChatService, didUpdateChatDialogInMemoryStorage chatDialog: QBChatDialog) {
		
        self.reloadTableViewIfNeeded()
    }
	
    func chatService(_ chatService: QMChatService,didUpdateChatDialogsInMemoryStorage dialogs: [QBChatDialog]){
		
        self.reloadTableViewIfNeeded()
    }
	
    func chatService(_ chatService: QMChatService, didAddChatDialogsToMemoryStorage chatDialogs: [QBChatDialog]) {
        
        self.reloadTableViewIfNeeded()
    }
    
    func chatService(_ chatService: QMChatService, didAddChatDialogToMemoryStorage chatDialog: QBChatDialog) {
        
        self.reloadTableViewIfNeeded()
    }
    
    func chatService(_ chatService: QMChatService, didDeleteChatDialogWithIDFromMemoryStorage chatDialogID: String) {
        
        self.reloadTableViewIfNeeded()
    }
    
    func chatService(_ chatService: QMChatService, didAddMessagesToMemoryStorage messages: [QBChatMessage], forDialogID dialogID: String) {
        
        self.reloadTableViewIfNeeded()
    }
    
    func chatService(_ chatService: QMChatService, didAddMessageToMemoryStorage message: QBChatMessage, forDialogID dialogID: String){
        
        self.reloadTableViewIfNeeded()
    }

    // MARK: QMChatConnectionDelegate
    
    func chatServiceChatDidFail(withStreamError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    
    func chatServiceChatDidAccidentallyDisconnect(_ chatService: QMChatService) {
        SVProgressHUD.showError(withStatus: "Chat disconnected")
    }
    
    func chatServiceChatDidConnect(_ chatService: QMChatService) {
        if !ServicesManager.instance().isProcessingLogOut! {
            self.getDialogs()
        }
    }
    
    func chatService(_ chatService: QMChatService,chatDidNotConnectWithError error: Error){
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
	
    func chatServiceChatDidReconnect(_ chatService: QMChatService) {
        if !ServicesManager.instance().isProcessingLogOut! {
            self.getDialogs()
        }
    }
    
    // MARK: - Helpers
    func reloadTableViewIfNeeded() {
        if !ServicesManager.instance().isProcessingLogOut! {
            self.tableView.reloadData()
        }
    }
}
