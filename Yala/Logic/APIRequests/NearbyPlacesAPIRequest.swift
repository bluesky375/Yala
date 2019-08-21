//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum NearbyPlacesType {
    case drinks(Location , String)
    case distance(Location, String, String, String, String, String)
    case price(Location, String, String)
    case cuisine(Location, String, String, String)
}

class NearbyPlacesAPIRequest: APIBaseRequest {
    
    private var requestType: NearbyPlacesType
    
    init(requestType: NearbyPlacesType) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .get
    }
    
    override var baseUrl: String {
        return "https://maps.googleapis.com/maps/api/"
    }
    
    override var path: String {
        return "place/nearbysearch/json"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .drinks(let location,let target):
            return ["location" : String(location.lat!) + "," + String(location.lng!),
                    "radius": "1000", // 10 kms
                    "type" : target,
                    "key" : "AIzaSyCUueSH6Fh73L_6Oh7Pdbi-N6-_KTNMegI",
                    ]
            
        case .distance(let location, let target, let distance, let minprice, let maxprice, let food):
            
            return ["location" : String(location.lat!) + "," + String(location.lng!),
                    //  "radius": "10000", // 10 kms
                "type" : target,
                "key" : "AIzaSyCUueSH6Fh73L_6Oh7Pdbi-N6-_KTNMegI",
                "radius": distance,
                "minprice" : minprice,
                "maxprice" : maxprice,
                "food" : food
            ]
            
        case .price(let location, let target, let price) :
            
            return ["location" : String(location.lat!) + "," + String(location.lng!),
                    //  "radius": "10000", // 10 kms
                "type" : target,
                "key" : "AIzaSyCUueSH6Fh73L_6Oh7Pdbi-N6-_KTNMegI",
                //price 0~4
                "minprice": price,
                "maxprice" : "4",
                "radius": "500"]
            
        case .cuisine(let location, let target,let distance, let food):
            
            return ["location" : String(location.lat!) + "," + String(location.lng!),
                    //  "radius": "10000", // 10 kms
                "type" : target,
                "key" : "AIzaSyCUueSH6Fh73L_6Oh7Pdbi-N6-_KTNMegI",
                "radius": distance,
                "food" : food
                ]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
