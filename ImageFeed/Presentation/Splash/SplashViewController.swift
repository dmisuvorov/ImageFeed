//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 03.02.2023.
//

import UIKit

class SplashViewController : UIViewController, AuthViewControllerDelegate {
    private let oAuth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    
    private let MainStoryboardName = "Main"
    private let TabBarViewControllerId = "TabBarViewController"
    private let AuthViewControllerId = "AuthViewController"
    private let NavigationControllerId = "NavigationController"
    private let ShowAuthenticationScreenSegueId = "ShowAuthenticationScreen"
    
    private lazy var mainStoryboard = UIStoryboard(name: MainStoryboardName, bundle: Bundle.main)
    private lazy var errorAlertPresenter = AlertPresenter(viewController: self)
    private var window: UIWindow? {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return nil
        }
        return window
    }
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "splash_screen_logo")
        imageView.image = image
        return imageView
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let accessToken = oAuth2TokenStorage.token,
              !accessToken.isEmpty else {
            switchToAuthViewController()
            return
        }

        UIBlockingProgressHUD.show()
        fetchProfile(token: accessToken)
    }
    
    //MARK: - AuthViewControllerDelegate
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    //MARK: - private func
    private func configureUI() {
        self.view.backgroundColor = UIColor.ypBlack
        self.view.addSubview(self.logoImageView, constraints: [
            equal(\.centerXAnchor, \.safeAreaLayoutGuide.centerXAnchor),
            equal(\.centerYAnchor, \.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func switchToAuthViewController() {
        guard
            let navigationController = mainStoryboard.instantiateViewController(withIdentifier: NavigationControllerId) as? UINavigationController,
            let authViewController = navigationController.viewControllers.first as? AuthViewController
        else {
            assertionFailure("Invalid Configuration")
            return
        }
        authViewController.delegate = self
        window?.rootViewController = authViewController
        window?.makeKeyAndVisible()
    }
    
    private func switchToTabBarController() {
        let tabBarController = mainStoryboard
            .instantiateViewController(withIdentifier: TabBarViewControllerId)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showErrrorAlert()
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let profile):
                self.fetchProfileImageURL(username: profile.username)
                self.switchToTabBarController()
            case .failure:
                self.showErrrorAlert()
            }
        }
    }
    
    private func fetchProfileImageURL(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profileSmallImageURL):
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self.profileImageService,
                        userInfo: ["URL" : profileSmallImageURL]
                    )
            case .failure:
                self.showErrrorAlert()
            }
        }
    }
    
    private func showErrrorAlert() {
        errorAlertPresenter.presentAlert(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            firstButtonTitle: "Ок",
            firstButtonAction: { self.switchToAuthViewController() }
        )
    }
}
