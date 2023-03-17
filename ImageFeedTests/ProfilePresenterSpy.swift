//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Суворов Дмитрий Владимирович on 17.03.2023.
//
import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var navigateToSplashControllerCalled = false
    
    func updateProfileDetails() {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func onLogout() {
        navigateToSplashControllerCalled = true
    }
    
    
}
