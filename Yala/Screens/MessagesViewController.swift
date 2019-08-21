//
//  MessagesViewController.swift
//  Yala
//
//  Created by Ankita on 10/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, VisibleTabBarProtocol {
    
    class func fromStoryboard() -> MessagesViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MessagesViewController.self)) as! MessagesViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        navigationController?.setNavigationBarAppearance(toType: .gradient)
    }
}
