//
//  OutletDetailViewController.swift
//  Yala
//
//  Created by Ankita on 04/12/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import MapKit
import ImageSlideshow
import Kingfisher
import Cosmos

class OutletDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var outletNameLabel: UILabel!
    @IBOutlet weak var openNowTaskView: UIStackView!
    @IBOutlet weak var outletAddress: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var callStoreButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    
    var selectedPlace: GooglePlaceItem?
    
    var photoURLs: [String]?
    
    let selectedAttributed = [NSAttributedStringKey.font: YalaThemeService.openSansRegularFont(ofSize: 13),
                              NSAttributedStringKey.foregroundColor: YalaThemeService.themeColor()]
    
    let unSelectedAttributed = [NSAttributedStringKey.font: YalaThemeService.openSansRegularFont(ofSize: 13),
                                NSAttributedStringKey.foregroundColor: UIColor.red]
    
    class func fromStoryboard() -> OutletDetailViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: OutletDetailViewController.self)) as! OutletDetailViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location Detail"
        navigationController?.setNavigationBarAppearance(toType: .gradient)
        setupBackButton(withAction: #selector(dismissMe))
        mapView.showsUserLocation = true
        displayData()
    }
    
    func displayData() {
        if selectedPlace?.photos == nil {
            imageSlider.isHidden = true
            mapView.isHidden = false
            
            setRegionLocation((selectedPlace?.getCLLOcation())!)
            
            let artwork = Artwork.init(selectedPlace!)
            mapView.addAnnotation(artwork)
        } else {
            imageSlider.isHidden = false
            mapView.isHidden = true
            fetchImageSource()
        }
        
        outletNameLabel.text = selectedPlace?.name
        outletAddress.text = selectedPlace?.address
        distanceLabel.text = selectedPlace?.distance
        
        typeLabel.text = selectedPlace?.types.first
        
        if selectedPlace?.openingHours?.openNow == true {
            let text = NSMutableAttributedString.init(string: "Open Now", attributes: selectedAttributed)
            openNowLabel.attributedText = text
        } else {
            let text = NSMutableAttributedString.init(string: "Closed", attributes: unSelectedAttributed)
            openNowLabel.attributedText = text
        }
        

        callStoreButton.isHidden = true
        
        let rating = selectedPlace?.rating ?? 0
        ratingView.rating = rating
        ratingLabel.text = "\(rating)"
    }
    
    func setRegionLocation(_ coordinate: CLLocationCoordinate2D) {
        let widthMeters: CLLocationDistance = 5000
        let heightMeters: CLLocationDistance = 5000
        mapView.region =  MKCoordinateRegionMakeWithDistance(coordinate, widthMeters, heightMeters)
    }
    
    func fetchImageSource() {
        guard  (selectedPlace?.photos != nil) else {
            return
        }
        
        var kingfisherSource: [InputSource] = [InputSource]()
        for item in (selectedPlace?.photos!)! {
            if item.photoReference != nil, item.photoReference!.isEmpty == false, let imageURL = item.getPhotoURL() {
             //   kingfisherSource.append(KingfisherSource(urlString: imageURL)!)
            }
        }
        
        imageSlider.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        imageSlider.backgroundColor = UIColor.black
        imageSlider.pageIndicatorPosition = PageIndicatorPosition.init(horizontal: .center
            , vertical: .bottom)
        imageSlider.contentScaleMode = UIViewContentMode.scaleAspectFit
        imageSlider.circular = false
        imageSlider.zoomEnabled = true
        
        imageSlider.setImageInputs(kingfisherSource)
    }
    
    @IBAction func directionButtonAction(_ sender: Any) {
        if selectedPlace?.geometry?.location != nil {
            OpenMaps.openInMaps(
                "\((selectedPlace?.getCLLOcation().latitude)!)",
                "\((selectedPlace?.getCLLOcation().longitude)!)",
                selectedPlace?.name)
        }
    }
    
    @IBAction func callStoreButtonAction(_ sender: Any) {
    
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        let vc = SelectDateTimeViewController.fromStoryboard()
        vc.selectedPlace = selectedPlace
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissMe() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
