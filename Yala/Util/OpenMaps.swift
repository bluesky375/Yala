//
//  Address+Maps.swift
//  TWGiOS
//
//  Created by Arpit Pittie on 29/09/17.
//  Copyright © 2018 the warranty group. All rights reserved.
//

import Foundation
import MapKit

class OpenMaps {
    static func openInMaps(_ latitude: String, _ longitude: String, _ name: String?) {
        let coordinates = CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
    
    static func openGoogleMaps(_ latitude: String, _ longitude: String, _ name: String) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
        } else {
            openInMaps(latitude, longitude, name)
        }
    }
}
