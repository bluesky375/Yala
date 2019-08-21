//
//  GooglePlace.swift
//  Yala
//
//  Created by Ankita on 11/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import MapKit

class OpeningHours: Codable {
    var openNow: Bool?
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

class GooglePlacePhoto: Codable {
    var photoReference: String?
    
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
    
    func getPhotoURL() -> String? {
        if photoReference != nil {
            return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + photoReference! + "&key=AIzaSyCUueSH6Fh73L_6Oh7Pdbi-N6-_KTNMegI"
        } else {
            return nil
        }
    }
    
}

class Location: Codable {
    var lat: Double?
    var lng: Double?
}

class Geometry: Codable {
    var location: Location?
}

class GooglePlaces: Codable {
    var results: [GooglePlaceItem]?
}

class GooglePlaceItem: Codable {
    var icon: String?
    var id: String?
    var name: String?
    var rating: Double?
    var address: String?
    var geometry: Geometry?
    var photoReference: String?
    var photos: [GooglePlacePhoto]?
    var distance: String?
    var openingHours: OpeningHours?
    var types: [String]
    
    func getCLLOcation() -> CLLocationCoordinate2D  {
        guard geometry?.location?.lat != nil && geometry?.location?.lng != nil  else {
            return CLLocationCoordinate2D()
        }
        
        return CLLocationCoordinate2D.init(latitude: (geometry?.location?.lat)!, longitude: (geometry?.location?.lng)!)
    }
    
    enum CodingKeys: String, CodingKey {
        case icon = "icon"
        case id = "id"
        case name = "name"
        case rating = "rating"
        case address = "vicinity"
        case geometry = "geometry"
        case photos = "photos"
        case openingHours = "opening_hours"
        case types = "types"
    }
    
    func getPhotoURL() -> String? {
        if photos != nil, (photos?.count)! > 0 {
            return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + photos![0].photoReference! + "&key=AIzaSyCUueSH6Fh73L_6Oh7Pdbi-N6-_KTNMegI"
        } else {
            return nil
        }
    }
}
