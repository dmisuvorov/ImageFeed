//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Суворов Дмитрий Владимирович on 20.03.2023.
//

@testable import ImageFeed
import XCTest

private let photoStub = Photo(
    id: "test",
    size: CGSize(width: 100, height: 100),
    createdAt: "2023-03-20T04:34:43Z",
    welcomeDescription: "test",
    thumbImageURL: "test",
    largeImageURL: "test",
    isLiked: false
)

final class ImageListTests: XCTestCase {
    private final class ImageListServiceStub: ImagesListServiceProtocol {
        var photos: [ImageFeed.Photo] = []
        func fetchPhotosNextPage() { photos.append(photoStub) }
        func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {}
    }
    
    func testFetchPhotosNextPage() {
        // Given
        let imageListServiceStub = ImageListServiceStub()
        let presenter = ImageListPresenter(imagesListService: imageListServiceStub)

        // When
        presenter.onViewDidLoad()

        // Then
        XCTAssertTrue(imageListServiceStub.photos.count == 1)
    }
    
    func testUpdateTableViewIfNeeded() {
        // Given
        let imageListServiceStub = ImageListServiceStub()
        let view = ImageListViewControllerSpy()
        let presenter = ImageListPresenter(imagesListService: imageListServiceStub)
        presenter.view = view

        // When
        imageListServiceStub.fetchPhotosNextPage()
        presenter.onDataUpdated()

        // Then
        XCTAssertTrue(view.updateTableViewAnimatedCalled == true)
    }
    
    func testOnCellWillDisplay() {
        // Given
        let imageListServiceStub = ImageListServiceStub()
        let view = ImageListViewControllerSpy()
        let presenter = ImageListPresenter(imagesListService: imageListServiceStub)
        presenter.view = view

        // When
        imageListServiceStub.fetchPhotosNextPage()
        presenter.onDataUpdated()
        presenter.onCellWillDisplay(row: 0)

        // Then
        XCTAssertTrue(imageListServiceStub.photos.count == 2)
    }
}
