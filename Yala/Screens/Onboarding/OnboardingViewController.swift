//
//  OnboardingViewController.swift
//  Yala
//
//  Created by Admin on 4/23/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var indicater1: UIImageView!
    @IBOutlet weak var indicater2: UIImageView!
    @IBOutlet weak var indicater3: UIImageView!
    @IBOutlet weak var indicater4: UIImageView!
    
    public struct Item {
        var header: String
        var image: String
        var title : String
        var text : String
        
        public init(header: String, image: String, title: String, text: String) {
            self.header = header
            self.image = image
            self.title = title
            self.text = text
        }
    }
    
  
    var galleryData = [
        Item(header: "1 of 4", image: "onboarding1", title :"An app that helps you see your friends more often.", text: "orem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut "),
        Item(header: "2 of 4", image: "onboarding2", title :"What's your vibe? Choose a place to meet.", text: "orem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut "),
        Item(header: "3 of 4", image: "onboarding3", title :"Check out what your friends are doing.", text: "orem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut "),
        Item(header: "4 of 4", image: "onboarding4", title :"Quickly organize plans and meet up with your friends!", text: "orem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut "),
            ]
    var galleryPointer = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initailIndicater()
    }
    
    class func fromStoryboard() -> OnboardingViewController {
        let vc = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: OnboardingViewController.self)) as! OnboardingViewController
        return vc
    }
    
    @IBAction func onTappedSkip(_ sender: Any) {
        let vc = LoginViewController.fromStoryboard()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onTappedContinue(_ sender: Any) {
        if galleryPointer == 3 {
            let vc = LoginViewController.fromStoryboard()
            navigationController?.pushViewController(vc, animated: true)
            return
             
        }
        galleryPointer = galleryPointer + 1
        collectionView.scrollToItem(at: IndexPath(item: galleryPointer, section: 0), at: .centeredHorizontally, animated: true)
        initailIndicater()
    }
    
    func initailIndicater(){
        indicater1.image = UIImage.init(named: "indicaterfalse")
        indicater2.image = UIImage.init(named: "indicaterfalse")
        indicater3.image = UIImage.init(named: "indicaterfalse")
        indicater4.image = UIImage.init(named: "indicaterfalse")
        
        switch (galleryPointer){
        case 0:
            indicater1.image = UIImage.init(named: "indicatertrue")
            break
        case 1:
            indicater2.image = UIImage.init(named: "indicatertrue")
            break
        case 2:
            indicater3.image = UIImage.init(named: "indicatertrue")
            break
        case 3:
            indicater4.image = UIImage.init(named: "indicatertrue")
            break
        default:
            indicater1.image = UIImage.init(named: "indicatertrue")
        }
    }
   

}
extension OnboardingViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        for c in collectionView.visibleCells {
            let i = collectionView.indexPath(for: c)
            galleryPointer = i!.item
            initailIndicater()
            break
        }
        
    }
    
}
extension OnboardingViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        let item = galleryData[indexPath.item]
        cell.labelText.text = item.header
        cell.imgOnboard.image = UIImage(named: item.image)
        cell.lblTitle.text = item.title
        cell.lblText.text  = item.text
        
       
        return cell
    }
    
}
extension OnboardingViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = CGSize(width: CGFloat(0), height: 0)
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        cellSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        return cellSize
        
    }
    
}

