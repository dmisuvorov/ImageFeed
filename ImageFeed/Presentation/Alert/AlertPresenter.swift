//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 15.02.2023.
//

import UIKit

final class AlertPresenter {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func presentAlert(title: String,
                      message: String,
                      firstButtonTitle: String,
                      firstButtonAction: @escaping (() -> Void),
                      secondButtonTitle: String? = nil,
                      secondButtonAction: (() -> Void)? = nil
    ) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        let firstAction = UIAlertAction(title: firstButtonTitle, style: .default) { _ in
            alert.dismiss(animated: true)
            firstButtonAction()
        }
        alert.addAction(firstAction)

        if let secondButtonTitle = secondButtonTitle, let secondButtonAction = secondButtonAction {
            let secondAction = UIAlertAction(title: secondButtonTitle, style: .default) { _ in
                alert.dismiss(animated: true)
                secondButtonAction()
            }
            alert.addAction(secondAction)
        }

        viewController?.present(alert, animated: true)
    }
}
