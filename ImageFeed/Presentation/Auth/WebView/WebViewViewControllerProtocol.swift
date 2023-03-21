//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 10.03.2023.
//
import UIKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    
    func load(request: URLRequest)
    
    func setProgressValue(_ newValue: Float)
    
    func setProgressHidden(_ isHidden: Bool)
}
