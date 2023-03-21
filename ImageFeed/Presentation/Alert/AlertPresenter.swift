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
                      accessibilityId: String? = nil,
                      firstButtonTitle: String,
                      firstButtonAccessibilityId: String? = nil,
                      firstButtonAction: @escaping (() -> Void),
                      secondButtonTitle: String? = nil,
                      secondButtonAccessibilityId: String? = nil,
                      secondButtonAction: (() -> Void)? = nil
    ) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        if accessibilityId != nil { alert.view.accessibilityIdentifier = accessibilityId }
        let firstAction = UIAlertAction(title: firstButtonTitle, style: .default) { _ in
            alert.dismiss(animated: true)
            firstButtonAction()
        }
        if firstButtonAccessibilityId != nil { firstAction.accessibilityLabel = firstButtonAccessibilityId }
        alert.addAction(firstAction)

        if let secondButtonTitle = secondButtonTitle, let secondButtonAction = secondButtonAction {
            let secondAction = UIAlertAction(title: secondButtonTitle, style: .default) { _ in
                alert.dismiss(animated: true)
                secondButtonAction()
            }
            if secondButtonAccessibilityId != nil { secondAction.accessibilityLabel = secondButtonAccessibilityId }
            alert.addAction(secondAction)
        }

        viewController?.present(alert, animated: true)
    }
}
