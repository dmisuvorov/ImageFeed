//
//  ImageListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Суворов Дмитрий Владимирович on 20.03.2023.
//

@testable import ImageFeed

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    var view: ImageFeed.ImageListViewControllerProtocol?
    var photosCount: Int = 0
    
    var onViewDidLoadCalled = false
    var onDataUpdatedCalled = false
    var onCellWillDisplayCalled = false
    var getPhotoOrNilByIndexCalled = false
    var imageListCellDidTapLikeCalled = false
    
    func onViewDidLoad() {
        onViewDidLoadCalled = true
    }
    
    func onDataUpdated() {
        onDataUpdatedCalled = true
    }
    
    func onCellWillDisplay(row index: Int) {
        onCellWillDisplayCalled = true
    }
    
    func getPhotoOrNilByIndex(row index: Int) -> ImageFeed.Photo? {
        getPhotoOrNilByIndexCalled = true
        return nil
    }
    
    func imageListCellDidTapLike(row index: Int, _ completion: @escaping (Result<ImageFeed.Photo, Error>) -> Void) {
        imageListCellDidTapLikeCalled = true
    }
}
