//
//  UnAuthenticatedRestAPIService.swift
//  TWGiOS
//
//  Created by Samiksha on 28/04/17.
//  Copyright © 2018 the warranty group. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class UnAuthenticatedRestAPIService: NSObject {
    
    static let shared = UnAuthenticatedRestAPIService()
    let GEOCODE_BASE_URL = "https://maps.googleapis.com/maps/api/geocode/json?address="
    let PLACES_BASE_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    let GEOCODE_GOOGLE_MAPS_KEY = "AIzaSyA2uPsFVphzhDdGSKtYcxUWdyE_y_AY0UY"
    
    func geocodeWithAddress(address: String, _ completionHandler: ((_ success: Bool, _ coordinate: CLLocationCoordinate2D?) -> ())?) {
        var urlString = GEOCODE_BASE_URL + address + "&key=" + GEOCODE_GOOGLE_MAPS_KEY
        urlString = urlString.replacingOccurrences(of: " ", with: "+")
        Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON {(response) in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 && response.data != nil {
                    let json = JSON(response.data!)
                    var coordinate: CLLocationCoordinate2D?
                    if let results = json["results"].array {
                        if results.count != 0 {
                            if let geometry = results[0]["geometry"].dictionary {
                                if let location = geometry["location"]?.dictionary {
                                    if let latitude = location["lat"]?.double, let longitude = location["lng"]?.double {
                                        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    }
                                }
                            }
                        }
                    }
                    completionHandler?(true, coordinate)
                } else {
                    completionHandler?(false, nil)
                }
            case .failure(let _):
                if completionHandler != nil {
                    DispatchQueue.main.async {
                        completionHandler!(false, nil)
                    }
                }
            }
        }
    }
    
    func processResponse(_ data: Data) -> Error {
        let json = JSON.init(data: data)
        if let errorMessage = json[0]["message"].string {
            return ErrorBuilder.init(withTitle:  nil, message: errorMessage).build()
        } else {
            return ErrorBuilder.init(withTitle: nil, message: "Something went wrong, please try again later.").build()
        }
    }
    
    func processError(_ error: Error) -> Error {
        switch (error as NSError).code {
        case NSURLErrorNotConnectedToInternet:
            return ErrorBuilder.init(withTitle: "Network Error", message: "Internet connection appears to be offline. Please check and try again later.").build()
            
        default:
             return ErrorBuilder.init(withTitle: nil, message: "Something went wrong, please try again later.").build()
            
        }
    }
}

