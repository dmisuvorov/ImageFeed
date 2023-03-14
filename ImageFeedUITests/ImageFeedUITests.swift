//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Суворов Дмитрий Владимирович on 14.03.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launch()
    }

    func testAuth() throws {
        // тестируем сценарий авторизации
    }
        
    func testFeed() throws {
        // тестируем сценарий ленты
    }
        
    func testProfile() throws {
        // тестируем сценарий профиля
    }
}
