//
//  BaseRouter.swift
//  Yala
//
//  Created by Ankita on 01/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

/**
    This class is used to construct the api requests. It contains all api related properties that is being set in order to construct a request object for a api call and creates URLRequest
 */

typealias APIParams = [String : Any]?

enum ResponseType {
    case object()
    case array()
    case anyJson()
}

enum AuthType: Int {
    case user
    case client
    case oAuth
    case noAuth
    
    var value: String {
        switch self {
        case .user:
            return "Bearer \(UserAccountManager.shared.getAuthorisationToken())"
        case .client:
            return "Bearer \(UserAccountManager.shared.getNonAuthenticatedAPIToken())"
        case .oAuth:
            return APIConfigProvider.oAuthToken
        default:
            return ""
        }
    }
}

protocol RestRequest {
    var method: HTTPMethod { get }
    var encoding: Alamofire.ParameterEncoding? { get }
    var path: String { get }
    var parameters: APIParams { get }
    var authType: AuthType { get }
    var responseType: ResponseType { get }
    var cacheResponse: Bool { get }
}

open class APIBaseRequest: RestRequest, URLRequestConvertible {
    
    init() {}
    
    var fatalMessage = "BaseRouter: Please implement following method while extending this class - " // TODO: Error mssaging using Reflect
    
    var method: HTTPMethod { fatalError(fatalMessage + "var:method") }
    var encoding: Alamofire.ParameterEncoding? { fatalError(fatalMessage + "var:encoding") }
    var path: String { fatalError(fatalMessage + "var:path") }
    var authType: AuthType { fatalError(fatalMessage + "var:authType") }
    var responseType: ResponseType { fatalError(fatalMessage + "var:responseType") }
    var cacheResponse: Bool { fatalError(fatalMessage + "var:cacheResponse") }
    var isMultiPartRequest: Bool = false
    
    var baseUrl: String {
        return APIConfigProvider.baseUrl
    }
    
    var parameters: APIParams {
        fatalError(fatalMessage + "var:parameters")
    }
    
    func commonHeaders() -> [(String, String)] {
        var headers: [(String, String)] = []
        
        // Authorization Header
        switch authType {
        case .noAuth:
            break
        default:
            headers.append(((authType.value, "Authorization")))
        }
        
        return headers
    }
    
    public func asURLRequest() throws -> URLRequest {
        let baseURL = try baseUrl.asURL()
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        for (value, field) in commonHeaders() {
            urlRequest.addValue(value, forHTTPHeaderField: field)
        }
        
        // Setup any request specific headers after commonHeaders call
        
        if let parameters = parameters {
            return try encoding!.encode(urlRequest, with: parameters)
        }
        
        if self.cacheResponse {
            urlRequest.cachePolicy = .returnCacheDataElseLoad
            urlRequest.addValue("private", forHTTPHeaderField: "Cache-Control")
        }
        
        print("\n \n asURLRequest", urlRequest)
        return urlRequest
    }
}
