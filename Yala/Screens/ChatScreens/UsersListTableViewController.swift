//
//  UsersListTableViewController.swift
//  sample-chat-swift
//
//  Created by Injoit on 6/3/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

import Foundation

class UsersListTableViewController: UITableViewController {
    
    var users : [QBUUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Fetching users from cache.
        
        let users = ServicesManager.instance().usersService.usersMemoryStorage.unsortedUsers()
            
            
            if users.count > 0 {
                
                guard let users = ServicesManager.instance().sortedUsers() else {
                    print("No cached users")
                    return
                }
                
                getYalaQuickBloxFriends(users, { [weak self] (users) in
                    self?.setupUsers(users: users)
                })
            }
            else {
                
               SpinnerWrapper.showSpinner()
                
                // Downloading users from Quickblox.
                
                ServicesManager.instance().downloadCurrentEnvironmentUsers(successBlock: {[weak self] (users) -> Void in
                    
                    SpinnerWrapper.hideSpinnerView()
                    
                    guard let unwrappedUsers = users else {
                        
                        SVProgressHUD.showError(withStatus: "No users downloaded")
                        return
                    }
            
                    self?.getYalaQuickBloxFriends(unwrappedUsers, { (users) in
                        self?.setupUsers(users: users)
                    })
                    
                    }, errorBlock: { (error) -> Void in
                        
                        SVProgressHUD.showError(withStatus: error.localizedDescription)
                })
            }
        setupBackButton()
        
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
		return users.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SA_STR_CELL_USER".localized, for: indexPath) as! UserTableViewCell
        
        let user = self.users[indexPath.row]
        
        cell.setColorMarkerText(String(indexPath.row + 1), color: YalaThemeService.themeColor())

        
//        cell.setColorMarkerText(String(indexPath.row + 1), color: ServicesManager.instance().color(forUser: user))
        
        if user.fullName != nil {
            cell.userDescription = user.fullName
        } else if user.email != nil {
            cell.userDescription = user.email
        } else if user.login != nil {
            cell.userDescription = user.login
        } else {
            cell.userDescription = ""
        }
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func setupUsers(users: [QBUUser]) {
        self.users = users
        self.tableView.reloadData()
    }
    
    func getYalaQuickBloxFriends(_ users: [QBUUser], _ completion: ((_ user: [QBUUser])->())?) {
        var filteredUsers = [QBUUser]()
        var currentUser = User.loadCurrentUser()
        
        if let friends = UserService.shared.friends, friends.count > 0 {
            for user in users {
                for friend in friends {
                    if user.login == friend.email, user.login != currentUser?.email {
                        if filteredUsers.contains(user) == false {
                            filteredUsers.append(user)
                        }
                    }
                }
            }
            
            if completion != nil {
                completion!(filteredUsers)
            }
        } else {
            SpinnerWrapper.showSpinner()
            
            UserService.shared.getFriends(currentUser!) { (success, error, friends) in
                SpinnerWrapper.hideSpinnerView()
                
                if let friends = friends, friends.count > 0 {
                    for user in users {
                        for friend in friends {
                            if user.login == friend.email, user.login != currentUser?.email {
                                if filteredUsers.contains(user) == false {
                                    filteredUsers.append(user)
                                }
                            }
                        }
                    }
                }
                
                if completion != nil {
                    completion!(filteredUsers)
                }
            }
        }
    }
}

