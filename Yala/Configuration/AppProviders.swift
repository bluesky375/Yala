//
//  AppManager.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This class provides current configService and themeServices references based on running application. They are initilized based on current running application bundle identifiers
 */
private class AppLoader {
    
    static let configService = App.currentApp.configService
    static let themeService = App.currentApp.themeService
}

/**
    This struct provides static variables for application contents like T&C, contactUs, aboutUs, FAQs and theme
 */
struct AppContentProvider {
    static let termsAndConsitionsLink = AppLoader.configService.termsAndConditionsURL()
    static let contactUs = AppLoader.configService.termsAndConditionsURL()
    static let aboutUs = AppLoader.configService.aboutUsURL()
    static let FAQs = AppLoader.configService.faqsURL()
    static let theme = AppLoader.themeService
}

/**
    This struct provides static variables to be used throught the app for baseURL, oAithToken, fixed header and api version
 */
struct APIConfigProvider {
    static let baseUrl = AppLoader.configService.serverBaseURL()
    static let oAuthToken = AppLoader.configService.oAuthToken()
    static let acceptHeader = AppLoader.configService.acceptHeader()
    static let apiVersion = AppLoader.configService.apiVersion()
}
