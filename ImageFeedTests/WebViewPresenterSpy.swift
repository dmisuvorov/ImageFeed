//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Суворов Дмитрий Владимирович on 14.03.2023.
//

import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
