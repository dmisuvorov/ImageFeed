//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Суворов Дмитрий Владимирович on 17.03.2023.
//

@testable import ImageFeed
import XCTest


final class ProfileTests: XCTestCase {
    private struct ProfileServiceStub: ProfileServiceProtocol {
        var profile: Profile? = Profile(username: "test", name: "test", loginName: "test", bio: "test")
        func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, Error>) -> Void) {}
    }
    
    private struct ProfileImageServiceStub: ProfileImageServiceProtocol {
        var avatarURL: String? = "https://api.unsplash.com"
        func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {}
    }
    
    func testProfileUpdateProfileDetailsCalled() {
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        // When
        _ = viewController.view

        // Then
        XCTAssertTrue(presenter.updateProfileDetailsCalled)
    }
    
    func testViewControllerSetProfileDetailsCalled() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let profileServiceStub = ProfileServiceStub()
        let profileImageServiceStub = ProfileImageServiceStub()
        let presenter = ProfilePresenter(
            profileService: profileServiceStub,
            profileImageService: profileImageServiceStub
        )
        viewController.presenter = presenter
        presenter.view = viewController

        // When
        presenter.updateProfileDetails()

        // Then
        XCTAssertTrue(viewController.setProfileDetailsCalled)
        XCTAssertTrue(viewController.setAvatarCalled)
    }
}
