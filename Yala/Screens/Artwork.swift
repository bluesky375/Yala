//
//  Artwork.swift
//  Yala
//
//  Created by Ankita on 11/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let item: GooglePlaceItem?
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.item = nil
        
        super.init()
    }
    
    init(_ item: GooglePlaceItem) {
        self.title = item.name
        self.locationName = item.address ?? ""
        self.discipline = "discipline"
        self.coordinate = item.getCLLOcation()
        self.item = item
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
