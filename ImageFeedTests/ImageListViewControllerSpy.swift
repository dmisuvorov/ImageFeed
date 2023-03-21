//
//  ImageListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Суворов Дмитрий Владимирович on 20.03.2023.
//

@testable import ImageFeed

final class ImageListViewControllerSpy : ImageListViewControllerProtocol {
    var presenter: ImageFeed.ImageListPresenterProtocol?
    
    var updateTableViewAnimatedCalled = false
    var showProgressCalled = false
    var dismissProgressCalled = false
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
    }
    
    func showProgress() {
        showProgressCalled = true
    }
    
    func dismissProgress() {
        dismissProgressCalled = true
    }
}
