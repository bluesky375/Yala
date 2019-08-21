//
//  ActionSheetBuilder.swift
//  TWGiOS
//
//  Created by Samiksha on 16/03/17.
//  Copyright © 2017 Coverati. All rights reserved.
//

import Foundation
import UIKit

enum ActionSheetBuilderType {
    case photoPicker, photoDelete
}

class ActionSheetBuilder: NSObject {
    var galleryPicker: (()->())?
    var cameraPicker: (()->())?
    var deletePhoto: (() -> ())?
    var replacePhoto: (() -> ())?
    var viewPhoto: (() -> ())?
    
    func buildMenuItems(forType type: ActionSheetBuilderType, inViewController viewController: UIViewController) {
        buildMenuItems(forType: type, inViewController: viewController, nil, nil)
    }
    
    func buildMenuItems(forType type: ActionSheetBuilderType, inViewController viewController: UIViewController, _ sourceRect: CGRect?, _ sourceView: UIView?) {
        var items = [UIAlertAction]()
        switch type {
        case .photoPicker:
            if galleryPicker != nil {
                let item = UIAlertAction.init(title: "Gallery", style: .default) {[unowned self] (action) in
                    self.galleryPicker!()
                }
                items.append(item)
            }
            
            if cameraPicker != nil {
                let item = UIAlertAction.init(title: "Camera", style: .default) {[unowned self] (action) in
                    self.cameraPicker!()
                }
                items.append(item)
            }
        case .photoDelete:
            if deletePhoto != nil {
                let item = UIAlertAction.init(title: "Delete", style: .default) {[unowned self] (action) in
                    self.deletePhoto!()
                }
                items.append(item)
            }
            
            if replacePhoto != nil {
                let item = UIAlertAction.init(title: "Replace", style: .default) {[unowned self] (action) in
                    self.replacePhoto!()
                }
                items.append(item)
            }
            
            if viewPhoto != nil {
                let item = UIAlertAction.init(title: "Preview", style: .default) {[unowned self] (action) in
                    self.viewPhoto!()
                }
                items.append(item)
            }
        }
        
        let item = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        items.append(item)
        
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        for item in items {
            actionSheet.addAction(item)
        }
        
        if let popoverPresentationController = actionSheet.popoverPresentationController {
            if sourceRect != nil {
                popoverPresentationController.sourceRect = sourceRect!
            }
            if sourceView != nil {
                popoverPresentationController.sourceView = sourceView!
            }
            popoverPresentationController.permittedArrowDirections = [.down, .up]
        }
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
