//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 16.03.2023.
//
import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private var oAuth2TokenStorage: OAuth2TokenStorageProtocol
    
    init(
        profileService: ProfileServiceProtocol = ProfileService.shared,
        profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
        oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.oAuth2TokenStorage = oAuth2TokenStorage
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        
        view?.setProfileDetails(name: profile.name, nickname: profile.loginName, bio: profile.bio)
        updateAvatar()
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.setAvatar(url: url)
    }
    
    func onLogout() {
        oAuth2TokenStorage.token = ""
        WebViewViewController.clearData()
        view?.navigateToSplashController()
    }
}
