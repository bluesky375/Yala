//
//  APIClient.swift
//  Yala
//
//  Created by Ankita on 06/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

/**
 This class is responsible for making api call using Alamofire. It makes api call and converts json data into respective model class. It handles array of models as json output and any other json object as well which is not integrated as a model.
 */

class APIBaseClient: SessionManager {
    
    private var apiMessages = APIMessages()
    
    init(_ apiMessages1: APIMessages, configuration: URLSessionConfiguration) {
        super.init(configuration: configuration)
        apiMessages = apiMessages1
    }
    
    func request<T:Codable>(_ baseRequest: APIBaseRequest, completionHandler: ((_ success: Bool, _ responseObject: T?, _ responseArray: [T]?, _ anyResponse: AnyObject? , _ error: CustomError?) -> Void)?) {
        
        request(baseRequest)
            .validate(statusCode: 200..<501)
            .responseData { [weak self] responseData in
                if responseData.result.isFailure || responseData.response == nil {
                    DispatchQueue.global().async {
                        let error = self?.processError(baseRequest, responseData)
                        DispatchQueue.main.async {
                            if completionHandler != nil {
                                completionHandler!(false, nil, nil, nil, error!)
                            }
                        }
                    }
                } else {
                    guard let json = responseData.result.value else {
                        let error = ErrorBuilder.init(withTitle: nil,
                                                      message: "No JSON response").build()
                        if completionHandler != nil {
                            completionHandler!(false, nil, nil, nil, error)
                        }
                        return
                    }
                    print("JSON DATA")
                    print(String.init(data: json, encoding: .utf8))
                    
                    if baseRequest.cacheResponse { // URL Data caching
                        if URLCache.shared.cachedResponse(for: responseData.request!) == nil {
                            debugPrint("**** \(baseRequest.path): OBJECT SAVING TO CACHE ****")
                            let cachedURLResponse = CachedURLResponse(response: responseData.response!, data: responseData.data!, userInfo: nil, storagePolicy: .allowed)
                            URLCache.shared.storeCachedResponse(cachedURLResponse, for: responseData.request!)
                        }
                    }
                    
                    switch baseRequest.responseType {
                    case .object:
                        DispatchQueue.global().async {
                            let decoder = APIBaseClient.jsonDecoder()
                            var parsedObject: T?
                            do {
                                parsedObject = try decoder.decode(T.self, from: json)
                            } catch let error {
                                
                            }
                            
                            
                            DispatchQueue.main.async {
                                if completionHandler != nil {
                                    completionHandler!(true, parsedObject, nil, nil, nil)
                                }
                            }
                        }
                    case .array:
                        var parsedArray: [T]?
                        let decoder = APIBaseClient.jsonDecoder()
                        parsedArray = try! decoder.decode([T].self, from: json)
                        
                        DispatchQueue.main.async {
                            if completionHandler != nil {
                                completionHandler!(true, nil, parsedArray, nil, nil)
                            }
                        }
                        
                    case .anyJson:
                        if let jsonObject = json.toJSON() {
                            DispatchQueue.main.async {
                                if completionHandler != nil {
                                    completionHandler!(true, nil, nil, jsonObject, nil)
                                }
                            }
                        } else {
                            let error = ErrorBuilder.init(withTitle: nil,
                                                          message: "JSON Serialisation Error").build()
                            if completionHandler != nil {
                                completionHandler!(false, nil, nil, nil, error)
                            }
                        }
                    }
                }
            }
    }
    
    private func processError(_ request: APIBaseRequest, _ responseData: DataResponse<Data>) -> CustomError {
        let statusCode = responseData.response?.statusCode ?? ErrorCodes.default
        var errorTitle = "No object for HTTP response"
        var errorMessage = "HTTP Response Error, Please Retry"
        
        if statusCode == 401 {
            errorTitle = request.authType == AuthType.oAuth ? "Login Error" : "API Error"
            errorMessage = request.authType == AuthType.oAuth ? "Wrong credentials" : "User is not authorised for the requested resource"
        } else if responseData.response?.statusCode == 500 || responseData.response?.statusCode == 404 {
            errorMessage = apiErrorMsg() + String(statusCode) + "E"
        } else if let nsError = responseData.error as NSError? {
            switch nsError.code {
            case URLError.notConnectedToInternet.rawValue:
                errorTitle = "Network Error"
                errorMessage = "Internet conenction appears to be offline."
            case URLError.timedOut.rawValue:
                errorTitle = "Timeout"
                errorMessage = "Request Timed out"
            default:
                guard let json = responseData.data,
                    let jsonString = String(data: json, encoding: .utf8),
                    !jsonString.isEmpty else {
                    return ErrorBuilder.init(withTitle: errorTitle,
                                             message: errorMessage, code: statusCode).build()
                }
                
                let decoder = APIBaseClient.jsonDecoder()
                
                var parsedObject: ErrorModel?
                var parsedOAuthObject: OAuthErrorModel?
                
                do {
                    parsedObject = try decoder.decode(ErrorModel.self, from: json) as ErrorModel
                } catch {
                    debugPrint("Unable to parse api error into ErrorModel")
                }
                
                if parsedObject == nil {
                    do {
                        parsedOAuthObject = try decoder.decode(OAuthErrorModel.self, from:json) as OAuthErrorModel
                    } catch {
                        debugPrint("Unable to parse api error into OAuthErrorModel")
                    }
                }
                
                if parsedObject != nil {
                    errorMessage = parsedObject?.getErrorMessage() ?? ""
                } else if parsedOAuthObject != nil {
                    errorMessage = parsedOAuthObject?.getErrorMessage() ?? ""
                } else {
                    errorMessage = self.apiErrorMsg() + String(statusCode) + "D"
                }
            }
        }
        
        let newError = ErrorBuilder.init(withTitle: errorTitle,
                                         message: errorMessage, code: statusCode).build()
        return newError
    }
    
    public func apiErrorMsg() -> String {
        return apiMessages.standardError + "\nError code: "
    }
    
    public func oauthErroMsg() -> String {
        return apiMessages.oauthError
    }
    
    static func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // TODO: date format to be kept centralized
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
}
