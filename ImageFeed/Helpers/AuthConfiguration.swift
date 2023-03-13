//
//  Constants.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 30.01.2023.
//
import Foundation

let AccessKey = "1BIWWhAo5Btj9-tsSV7qNXkgqxVR2ilNKRtZBRgSkBQ"
let SecretKey = "WKdg9rSB9sUUEbyp9ih3BKfaHfy7INcu5WvOGdGW3Tg"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashTokenURL = URL(string: "https://unsplash.com/oauth/token")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: AccessKey,
            secretKey: SecretKey,
            redirectURI: RedirectURI,
            accessScope: AccessScope,
            defaultBaseURL: DefaultBaseURL,
            unsplashTokenURL: UnsplashTokenURL,
            unsplashAuthorizeURLString: UnsplashAuthorizeURLString
        )
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let unsplashTokenURL: URL
    let unsplashAuthorizeURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, unsplashTokenURL: URL, unsplashAuthorizeURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashTokenURL = unsplashTokenURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
    }
}
