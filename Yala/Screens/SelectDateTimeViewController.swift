//
//  SelectDateTimeViewController.swift
//  Yala
//
//  Created by Ankita on 15/10/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

class SelectDateTimeViewController: UIViewController {
    
    @IBOutlet weak var datePickerField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedPlace: GooglePlaceItem!

    class func fromStoryboard() -> SelectDateTimeViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: SelectDateTimeViewController.self)) as! SelectDateTimeViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Invite"
        setupBackButton()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.becomeFirstResponder()
    }
    
    func setupView() {
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePickerField.text = datePicker.date.toString(inFormat: "MM/dd/YYYY  hh:mm a")
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        datePickerField.text = datePicker.date.toString(inFormat: "MM/dd/YYYY  hh:mm a")
    }
    
    @IBAction func nextAction(_ sender: Any) {
        datePicker.resignFirstResponder()
        
        let invite = Invite()
        invite.selectedPlace = selectedPlace
        invite.dateTime = datePicker.date
        
        let vc = FriendsViewController.fromStoryboard()
        vc.cellType = .checkBox
        vc.showBackButton = true
        vc.showTabBar = false
        vc.invite = invite
        navigationController?.pushViewController(vc, animated: true)
    }
}
