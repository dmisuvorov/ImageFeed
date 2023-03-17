//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Суворов Дмитрий Владимирович on 17.03.2023.
//
import ImageFeed
import UIKit

final class ProfileViewControllerSpy : ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var setProfileDetailsCalled = false
    var setAvatarCalled = false
    var navigateToSplashControllerCalled = false
    
    func setProfileDetails(name: String, nickname: String, bio: String?) {
        setProfileDetailsCalled = true
    }
    
    func setAvatar(url: URL) {
        setAvatarCalled = true
    }
    
    func navigateToSplashController() {
        navigateToSplashControllerCalled = true
    }
}
