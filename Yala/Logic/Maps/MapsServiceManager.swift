//
//  MapsServiceManager.swift
//  TWGiOS
//
//  Created by Arpit Pittie on 24/07/17.
//  Copyright © 2018 the warranty group. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

protocol MapsLocationManagerDelegate: class {
    func mapsLocationManager(didUpdateLocation location: CLLocation)
    func mapsLocationManager(didFailWithError error: Error)
    func mapsLocationManager(didChangeAuthorizationStatus status: CLAuthorizationStatus)
}

class MapsServiceManager: NSObject {
    
    static let shared = MapsServiceManager()
    private let locationManager = CLLocationManager()
    private let marker = GMSMarker()
    private var fetcher = GMSAutocompleteFetcher()
    private let geocoder = GMSGeocoder()
    weak var locationManagerDelegate: MapsLocationManagerDelegate?
    
    var autoCompleteFailedAction: ((_ error: Error) -> ())?
    var autoCompleteSuccessAction: ((_ predictions: [GMSAutocompletePrediction]) -> ())?
    
    var distanceFilter: CLLocationDistance {
        get {
            return locationManager.distanceFilter
        }
        set(newValue) {
            locationManager.distanceFilter = newValue
        }
    }
    
    var zoomLevel: Float = 17
    
    func mapsLocationManager() -> CLLocationManager {
        return locationManager
    }
    
    func mapsMarker() -> GMSMarker {
        return marker
    }
    
    func mapsPlacesClient() -> GMSPlacesClient {
        return GMSPlacesClient.shared()
    }
    
    func mapsCoordinateBounds(forRegion region: GMSVisibleRegion) -> GMSCoordinateBounds {
        return GMSCoordinateBounds(region: region)
    }
    
    func mapsAutocompleteFetcher(forRegion region: GMSVisibleRegion) -> GMSAutocompleteFetcher? {
        let bounds = mapsCoordinateBounds(forRegion: region)
        fetcher.autocompleteBounds = bounds
        fetcher.delegate = self
        return fetcher
    }
    
    func mapsAutocompleteFetcher() -> GMSAutocompleteFetcher? {
        fetcher.autocompleteBounds = nil
        fetcher.delegate = self
        return fetcher
    }
    
    override init() {
        super.init()
        setup()
    }
    
    static func registerGoogleMapsServices() {
        GMSServices.provideAPIKey("AIzaSyA2uPsFVphzhDdGSKtYcxUWdyE_y_AY0UY")
        GMSPlacesClient.provideAPIKey("AIzaSyA2uPsFVphzhDdGSKtYcxUWdyE_y_AY0UY")
    }
    
    private func setup() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        distanceFilter = 20
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D, _ completionHandler: ((_ success: Bool, _ address: GMSAddress?) -> ())?) {
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                completionHandler?(true, address)
            } else {
                completionHandler?(false, nil)
            }
        }
    }
    
    func geocodeAddress(address: String, _ completionHandler: ((_ success: Bool, _ coordinate: CLLocationCoordinate2D?) -> ())?) {
        UnAuthenticatedRestAPIService.shared.geocodeWithAddress(address: address) {(success, coordinate) in
            completionHandler?(success, coordinate)
        }
    }
    
    func setMarker(atPosition position: CLLocationCoordinate2D) {
        marker.position = position
    }
}

// MARK: CLLocationManagerDelegate methods

extension MapsServiceManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        locationManagerDelegate?.mapsLocationManager(didUpdateLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManagerDelegate?.mapsLocationManager(didChangeAuthorizationStatus: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManagerDelegate?.mapsLocationManager(didFailWithError: error)
    }
}

// MARK: GMSAutocompleteFetcherDelegate methods

extension MapsServiceManager: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        if autoCompleteSuccessAction != nil {
            autoCompleteSuccessAction!(predictions)
        }
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        if autoCompleteFailedAction != nil {
            autoCompleteFailedAction!(error)
        }
    }
}
