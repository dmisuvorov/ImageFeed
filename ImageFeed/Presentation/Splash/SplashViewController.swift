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
    private lazy var errorAlertPresenter = AlertPresenter(viewController: self)
    
    private let MainStoryboardName = "Main"
    private let TabBarViewControllerId = "TabBarViewController"
    private let ShowAuthenticationScreenSegueId = "ShowAuthenticationScreen"
    
    //MARK: - LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let accessToken = oAuth2TokenStorage.token
        if accessToken != Empty {
            UIBlockingProgressHUD.show()
            fetchProfile(token: accessToken)
            return
        }
        switchToAuthViewController()
    }
    
    //MARK: - AuthViewControllerDelegate
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        vc.dismiss(animated: true)
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    //MARK: - private func
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: MainStoryboardName, bundle: Bundle.main)
            .instantiateViewController(withIdentifier: TabBarViewControllerId)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.errorAlertPresenter.presentAlert(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    firstButtonTitle: "Ок",
                    firstButtonAction: { self.switchToAuthViewController() }
                )
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.fetchProfileImageURL(username: profile.username)
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.errorAlertPresenter.presentAlert(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    firstButtonTitle: "Ок",
                    firstButtonAction: { self.switchToAuthViewController() }
                )
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
                self.errorAlertPresenter.presentAlert(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    firstButtonTitle: "Ок",
                    firstButtonAction: { self.switchToAuthViewController() }
                )
            }
        }
    }
}

//MARK: - Switch to Auth flow
extension SplashViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueId {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let authViewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueId)") }
            authViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToAuthViewController() {
        performSegue(withIdentifier: ShowAuthenticationScreenSegueId, sender: nil)
    }
}
