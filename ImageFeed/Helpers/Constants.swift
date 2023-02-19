//
//  Constants.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 30.01.2023.
//
import Foundation

final class Constants {
    
    static let accessKey = "1BIWWhAo5Btj9-tsSV7qNXkgqxVR2ilNKRtZBRgSkBQ"
    static let secretKey = "WKdg9rSB9sUUEbyp9ih3BKfaHfy7INcu5WvOGdGW3Tg"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashTokenURL = URL(string: "https://unsplash.com/oauth/token")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
