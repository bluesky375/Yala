//
//  Distance.swift
//  PizzaFactory
//
//  Created by Ankita on 14/11/18.
//  Copyright © 2018 Punchh Inc. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocation {
    
    func distanceFrom(_ location: CLLocation) -> Double {
        let c1 = coordinate
        let c2 = location.coordinate
        
        let p1 = MKMapPointForCoordinate(c1)
        let p2 = MKMapPointForCoordinate(c2)
        
        let distanceInMeters = MKMetersBetweenMapPoints(p1, p2)
    
        return distanceInMeters
    }
}

extension Double {
    
    func toMiles() -> String {
        var distance = ""
        
        let miles = self/1609
        if miles < 1 {
            distance = "\(Int(self))" + " m"
        } else {
            distance = "\(Int(miles))" +  " miles"
        }
        return distance
    }
    
}
