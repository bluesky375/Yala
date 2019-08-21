//
//  EditProfileViewController.swift
//  Yala
//
//  Created by Ankita on 30/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import EMSpinnerButton
import Kingfisher
import AAPickerView

class EditProfileViewController: UIViewController {
    
    weak var saveSpinnerButton: EMSpinnerButton!
    
    @IBOutlet weak var imageView: CircularImageView!
    @IBOutlet weak var firstname: YalaRectangularFields!
    @IBOutlet weak var lastname: YalaRectangularFields!
    @IBOutlet weak var fullName: YalaRectangularFields!
    @IBOutlet weak var email: YalaRectangularFields!
    @IBOutlet weak var mobile: YalaRectangularFields!
    @IBOutlet weak var gender: YalaUnderlinePicker!
    @IBOutlet weak var aboutYou: YalaRectangularFields!
    
    var user: User!
    
    var popoverRect: CGRect?
    var popoverSourceView: UIView?
    var mediaPickerHelper = MediaPickerHelper.init([.singleSelect, .circularCrop])
    var imageAsset: ImageAsset?
    
    class func fromStoryboard() -> EditProfileViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EditProfileViewController.self)) as! EditProfileViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        navigationController?.setNavigationBarAppearance(toType: .gradient)
        setupBarButtons()
        user = User.loadCurrentUser()
        setupValues()
        addTapGesture()
        setupView()
        
        firstname.isHidden = true
        lastname.isHidden = true
    }
    
    func setupBarButtons() {
        let leftButton = UIBarButtonItem.init(image: UIImage.init(named: "downArrow"), style: .plain, target: self, action: #selector(EditProfileViewController.dismissMe))
        leftButton.tintColor = UIColor.white
        
        let saveSpinnerButton1 = EMSpinnerButton.init(title: "Save")
        saveSpinnerButton1.backgroundColor = UIColor.clear
        saveSpinnerButton1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        saveSpinnerButton1.addTarget(self, action: #selector(EditProfileViewController.saveAction), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView: saveSpinnerButton1)
        
        saveSpinnerButton = saveSpinnerButton1
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
    }
    
    func setupView() {
        gender.pickerType = .string(data: ["Male", "Female"])
    }
    
    func setupValues() {
        email.text = user.email
        firstname.text = user.firstName
        lastname.text = user.lastName
        
        fullName.text = (user.firstName ?? "") + " " + (user.lastName ?? "")
        
        gender.text = user.displayGenderValue()
        mobile.text = user.mobile
        aboutYou.text = user.aboutYou
        
        if user.profileimage != nil {
            imageView.kf.setImage(with: URL(string: user.profileimage!), placeholder: UIImage(named: "empty_profile_icon"), options: [.cacheOriginalImage])
        }
    }
    
    func addTapGesture() {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.showImageUploadOptions))
        popoverSourceView = imageView
        popoverRect = imageView.bounds
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTapGesture)
    }
    
    @objc func showImageUploadOptions() {
        
        let storagePath = "Yala/Profile"
        
        mediaPickerHelper.showImageUploadOptionsIn(self, popoverRect, popoverSourceView, storagePath, "Profile.jpg") { (success, error, images) in
            if success && images != nil && (images?.count)! > 0 {
                let imageAssets = images! as [ImageAsset]
                self.imageAsset = imageAssets[0]
                self.imageView.image = self.imageAsset?.readFileFromFolder()
                self.imageView.backgroundColor = UIColor.clear
            } else {
                self.showAlert(withTitle: "", message: "Something went wrong. Please try again later.")
            }
        }
    }
    
    @objc func dismissMe() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveAction() {
        if validateAllFields() {
            let editedUser = User()
            editedUser.firstName = firstname.text
            editedUser.lastName = lastname.text
            editedUser.email = email.text
            editedUser.mobile = mobile.text
            editedUser.username = user.username
            
            if gender.text == "Male" {
                editedUser.gender = "M"
            } else if gender.text == "Female" {
                editedUser.gender = "F"
            }
            
            editedUser.aboutYou = aboutYou.text
            editedUser.imageAsset = imageAsset
            
            view.endEditing(true)
            
            view.isUserInteractionEnabled = false
            saveSpinnerButton.animate(animation: .collapse)
            UserService.shared.updateProfile(editedUser) { [weak self] (success, error, user) in
                self?.saveSpinnerButton.animate(animation: .expand)
                self?.view.isUserInteractionEnabled = true
                if user?.error == false {
                    User.saveUser(user: user!)
                    
                    ListenerDispatcher.shared.fire(event: UpdateProfileEvent())
                    
                    self?.showAlert(withTitle: "", message: "Details updated successfully", postDismisshandler: {
                        self?.dismissMe()
                    })
                } else if user?.message != nil {
                    self?.showAlert(withTitle: "", message: user?.message)
                } else {
                    self?.showAlert(withTitle: "", message: "Something went wrong, please try again later.")
                }
            }
            
        }
    }
}

extension EditProfileViewController {
    
    func validateAllFields() -> Bool {
        return true
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fullName {
            textField.isHidden = true
            firstname.isHidden = false
            lastname.isHidden = false
            firstname.becomeFirstResponder()
        }
    }
}
