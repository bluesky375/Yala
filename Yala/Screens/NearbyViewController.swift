//
//  NearbyViewController.swift
//  Yala
//
//  Created by Ankita on 07/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import MapKit
import GooglePlaces
import Lottie
import Cosmos
import iOSDropDown

class NearbyViewController: UIViewController, VisibleTabBarProtocol {
    
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeDetailView: YalaCorneredView!
    @IBOutlet weak var selectedPlaceTitle: UILabel!
    @IBOutlet weak var selectedPlaceDetail: UILabel!
    @IBOutlet weak var selectedPlaceDistance: UILabel!
    @IBOutlet weak var selectedPlaceImage: CircularImageView!
    @IBOutlet weak var drinksButton: UIButton!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var drinksIndicator: UIView!
    @IBOutlet weak var restaurantIndicator: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var openingLabel: UILabel!
    
    var currentLocationArtwork: Artwork?
    var currentUserLocation: CLLocationCoordinate2D?
    var selectedPlace: GooglePlaceItem?
    var selectedAnnotationView: MKAnnotationView?
    let mapLocationManager = MapsServiceManager()
    var sortByType = 0
    var searchTarget = "bar"
    var customSearchMode = false
    var customSearchfilter : [String] = []
    
    var nearbyPlaces = [GooglePlaceItem]()
    
    let selectedAttributed = [NSAttributedStringKey.font: YalaThemeService.openSansRegularFont(ofSize: 13),
                              NSAttributedStringKey.foregroundColor: YalaThemeService.themeColor()]
    
    let unSelectedAttributed = [NSAttributedStringKey.font: YalaThemeService.openSansRegularFont(ofSize: 13),
                              NSAttributedStringKey.foregroundColor: UIColor.red]
    
    class func fromStoryboard() -> NearbyViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: NearbyViewController.self)) as! NearbyViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTarget = "bar"
        setupMaps()
        setupMapsServices()
        didSelectButton(drinksButton)
        ratingView.settings.fillMode = .precise
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.requrieGoogleMapSearch), name: NSNotification.Name(rawValue: "requrieGoogleMapSearch"), object: nil)
        
    }
    
    func setupMaps() {
        mapView.delegate = self
        mapView!.mapType = MKMapType.standard
        mapView!.showsUserLocation = true
        mapView!.showsTraffic = false
        mapView.isZoomEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
        panGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
    }
    
    func setRegionLocation(_ coordinate: CLLocationCoordinate2D) {
        let widthMeters: CLLocationDistance = 1000
        let heightMeters: CLLocationDistance = 1000
        mapView.region =  MKCoordinateRegionMakeWithDistance(coordinate, widthMeters, heightMeters)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupAppearance()
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                locationServicesDenied()
            case .authorizedWhenInUse:
                mapLocationManager.mapsLocationManager().startUpdatingLocation()
            default: break
            }
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAppearance()
    }
    
    func locationServicesDenied() {
        showAlert(withTitle:  "Allow \"Yala\" to access your location while you use the app?",
                  message: "That allows fetching your location for services to Yala",
                  cancelButtonTitle: "Cancel",
                  otherButtonTitle: "Go to settings",
                  cancelButtonPostHandler: {[unowned self] in
            self.navigationController?.popViewController(animated: true)
            }, otherButtonPostHandler: {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        })
    }
    
    func setupMapsServices() {
        mapLocationManager.locationManagerDelegate = self
        mapLocationManager.mapsLocationManager().requestWhenInUseAuthorization()
        mapLocationManager.mapsLocationManager().startUpdatingLocation()
      //  currentUserLocation = mapView.region.center
        currentUserLocation = mapLocationManager.mapsLocationManager().location?.coordinate
    }
    
    func locationAuthorizationGranted() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                return true
            default:
                return false
            }
        }
        return false
    }
    
    func getNearbyRestaurant(_ placeID: String) {
        let client = GMSPlacesClient.init()
        client.lookUpPlaceID(placeID) {[weak self] (result, error) in
            if ((result?.coordinate) != nil) {
                if self?.mapView.annotations != nil && (self?.mapView.annotations.count)! > 0 {
                    self?.mapView.removeAnnotations(self!.mapView.annotations)
                }
                self?.setRegionLocation((result?.coordinate)!)
                self?.getNearbyRestaurants((result?.coordinate)!)
            }
        }
    }
    
    func getNearbyRestaurants(_ coordinate: CLLocationCoordinate2D) {
        let location1 = Location()
        location1.lng = coordinate.longitude
        location1.lat = coordinate.latitude
      
        if(customSearchMode){ if(customSearchfilter[2]=="4"&&customSearchfilter[3]=="0"){
                APIManager.shared.request(NearbyPlacesAPIRequest.init(requestType: NearbyPlacesType.cuisine(location1, searchTarget,customSearchfilter[1], customSearchfilter[4]))) { [weak self] (success, response: GooglePlaces?, _, otherResponse, error) in
                    if response != nil, response?.results != nil {
                        
                        self?.updateNearbyPlaces(withNewPlace: (response?.results)!)
                        
                    }
                }
            }else{ APIManager.shared.request(NearbyPlacesAPIRequest.init(requestType: NearbyPlacesType.distance(location1, searchTarget, customSearchfilter[1], customSearchfilter[2], customSearchfilter[3], customSearchfilter[4]))) { [weak self] (success, response: GooglePlaces?, _, otherResponse, error) in
                    if response != nil, response?.results != nil {
                        self?.updateNearbyPlaces(withNewPlace: (response?.results)!)
                        
                    }
                }
            }
            
        }else{
            APIManager.shared.request(NearbyPlacesAPIRequest.init(requestType: NearbyPlacesType.drinks(location1, searchTarget))) { [weak self] (success, response: GooglePlaces?, _, otherResponse, error) in
                if response != nil, response?.results != nil {
                    self?.updateNearbyPlaces(withNewPlace: (response?.results)!)
                    
                }
            }
            
        }
        
       
    }
    
    func updateNearbyPlaces(withNewPlace places: [GooglePlaceItem]) {
        var newPlaces = [GooglePlaceItem]()
        nearbyPlaces = []
        for place in places {
//            if nearbyPlaces.first(where: { $0.id == place.id }) != nil {
//                // do nothing item already exists
//            } else {
                nearbyPlaces.append(place)
                newPlaces.append(place)
//            }
        }
        
        showPinsForGooglePlaces(newPlaces)
    }
    
    func showPinsForGooglePlaces(_ places: [GooglePlaceItem]) {
        for item in places {
            let artwork = Artwork.init(item)
            self.mapView.addAnnotation(artwork)
        }
    }
    
    func showCurrentLocationPin(_ location: CLLocationCoordinate2D) {
        if currentLocationArtwork != nil {
            self.mapView.removeAnnotations([currentLocationArtwork!])
        }
        
        let artwork = Artwork(title: "Current location", locationName: "", discipline: "discipline", coordinate: location)
        currentLocationArtwork = artwork
        //self.mapView.addAnnotation(artwork)
    }
    
    @objc func requrieGoogleMapSearch(notification : NSNotification){
        let data = notification.object as! [String]
        customSearchMode = true
        customSearchfilter = data
        if((self.mapView.annotations.count) > 0) {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        mapLocationManager.mapsLocationManager().startUpdatingLocation()
        getNearbyRestaurants(currentUserLocation!)
        
        
        
    }
    
    @IBAction func setCurrentLocation(_ sender: Any) {
        mapLocationManager.mapsLocationManager().startUpdatingLocation()
        if let userLocation = mapLocationManager.mapsLocationManager().location?.coordinate {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 1000, 1000)
            mapView.setRegion(viewRegion, animated: false)
        }
    }
    
    @IBAction func confirmLocationAction(_ sender: Any) {
        let vc = SelectDateTimeViewController.fromStoryboard()
        vc.selectedPlace = selectedPlace
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func lcoationDetailAction(_ sender: Any) {
        let vc = OutletDetailViewController.fromStoryboard()
        vc.selectedPlace = selectedPlace
        let navigationController = UINavigationController.init(rootViewController: vc)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func presentSearchPopUp(_ sender: Any) {
        let vc = SearchFilterViewController.fromStoryboard()
        present( vc , animated: true)
    }
    
    
    @objc func didDragMap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            //let center: CLLocationCoordinate2D = mapView.region.center
            //getNearbyRestaurants(currentUserLocation!)
        }
    }
    
    func updateUserLocationOnServer() {
        guard  currentUserLocation != nil else {
            return
        }
        
        let lat = "\((currentUserLocation?.latitude)!)"
        let long = "\((currentUserLocation?.longitude)!)"
        
        UserService.shared.lastDeviceLatitude = lat
        UserService.shared.lastDeviceLongitude = long
        
        APIManager.shared.request(UpdateGPSLocationAPIRequest.init(requestType: UpdateGPSLocationEndPoint.updateGPS(lat, long))) { (success, response: GenericResponse?, _, _, _) in
       
        }
    }
    
    @IBAction func didSelectButton(_ sender: UIButton) {
        if drinksButton ==  sender {
            drinksIndicator.backgroundColor = YalaThemeService.themeColor()
            restaurantIndicator.backgroundColor = UIColor.clear
            searchTarget = "bar"
            
        } else if restaurantButton == sender {
            drinksIndicator.backgroundColor = UIColor.clear
            restaurantIndicator.backgroundColor = YalaThemeService.themeColor()
            searchTarget = "restaurant"
        } 
        self.mapView.removeAnnotations(self.mapView.annotations)
        mapLocationManager.mapsLocationManager().startUpdatingLocation()
        if(currentUserLocation==nil){
            
        }else{
            getNearbyRestaurants(currentUserLocation!)
        }
   //     getNearbyRestaurants(currentUserLocation!)
    }
}

extension NearbyViewController {
    
    func setupAppearance() {
//        let image = YalaThemeService.imageLayerForGradientBackground(bounds: searchBar.bounds)
//        searchBar.setBackgroundImage(image, for: .any, barMetrics: .default)
    
        
    }
}

//  MARK:- MapsLocationManagerDelegate methods

extension NearbyViewController: MapsLocationManagerDelegate {
    
    func mapsLocationManager(didFailWithError error: Error) {
        mapLocationManager.mapsLocationManager().stopUpdatingLocation()
    }
    
    func mapsLocationManager(didUpdateLocation location: CLLocation) {
        currentUserLocation = location.coordinate
        setRegionLocation(location.coordinate)
        getNearbyRestaurants(location.coordinate)
        updateUserLocationOnServer()
        getNearbyRestaurants(currentUserLocation!)
    }
    
    func mapsLocationManager(didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            navigationController?.popViewController(animated: true)
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            mapLocationManager.mapsLocationManager().startUpdatingLocation()
        default: break
        }
    }
}

extension NearbyViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: MKAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }

            switch(searchTarget) {
            case "bar" :
                view.image = UIImage(named: "drink_artwork")
                break
            case "restaurant" :
                view.image = UIImage(named: "restaurant_artwork")
                break
           
            default:
                view.image = UIImage(named: "drink_artwork")
                break
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let artwork = view.annotation as? Artwork, artwork != currentLocationArtwork {
            placeDetailView.isHidden = false
            selectedPlaceTitle.text = artwork.title
            selectedPlaceDetail.text = artwork.locationName
            selectedPlace = artwork.item
            let rating = selectedPlace?.rating ?? 0
            ratingView.rating = rating
            ratingLabel.text = "\(rating)"
            typeLabel.text = selectedPlace?.types.first
            
            if selectedAnnotationView != nil {
                switch(searchTarget) {
                case "bar" :
                    selectedAnnotationView?.image = UIImage(named: "drink_artwork")
                    break
                case "restaurant" :
                    selectedAnnotationView?.image = UIImage(named: "restaurant_artwork")
                    break
                default:
                    break
                }
            }

            if selectedPlace?.openingHours?.openNow == true {
                let text = NSMutableAttributedString.init(string: "Open Now", attributes: selectedAttributed as [NSAttributedStringKey : Any])
                openingLabel.attributedText = text
            } else {
                let text = NSMutableAttributedString.init(string: "Closed", attributes: unSelectedAttributed as [NSAttributedStringKey : Any])
                openingLabel.attributedText = text
            }
            
            view.image = UIImage(named: "selected_artwork")
            selectedAnnotationView = view
            
            var distance = ""
            if currentUserLocation != nil {
                let p1 = MKMapPointForCoordinate(artwork.coordinate)
                let p2 = MKMapPointForCoordinate(currentUserLocation!)
                
                let distanceInMeters = MKMetersBetweenMapPoints(p1, p2)
                let feets = distanceInMeters * 3.2
                
                let miles = distanceInMeters/1609
                if miles < 1 {
                    distance = "\(Int(feets))" + " Feets"
                } else {
                    distance = "\(Int(miles))" +  "+  Miles"
                }
            }
            
            selectedPlaceDistance.text = distance
            selectedPlace?.distance = distance
            
            if let photoURL = artwork.item?.getPhotoURL() {
                selectedPlaceImage.kf.setImage(with: URL(string: photoURL), placeholder: UIImage(named: "drinks_icon"), options: [.cacheOriginalImage])
            } else {
                selectedPlaceImage.image = UIImage.init(named: "drinks_icon")
            }
        }
    }
}


extension NearbyViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
