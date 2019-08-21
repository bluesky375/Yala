//
//  WebViewController.swift
//  Yala
//
//  Created by Ankita on 05/02/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var screenTitle: String?
    var urlStr: String!

    class func fromStoryboard() -> WebViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: WebViewController.self)) as! WebViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarAppearance(toType: .white)
        navigationItem.title = screenTitle
        setupBarButtons()
        
        self.webView.delegate = self
        if urlStr.trim().count > 0 {
            self.webView.loadRequest(URLRequest(url: URL(string: urlStr)!))
        }
    }
    
    func setupBarButtons() {
        let leftButton = UIBarButtonItem.init(image: UIImage.init(named: "downArrow"), style: .plain, target: self, action: #selector(dismissMe))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func dismissMe() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension WebViewController : UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SpinnerWrapper.showSpinner()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SpinnerWrapper.hideSpinnerView()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SpinnerWrapper.hideSpinnerView()
    }
}
