//
//  ImageListViewControllerTests.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 04.02.2025.
//

import XCTest
@testable import Image_Feed

final class ImageListViewControllerSpy_Tests: XCTestCase {
    var viewControllerSpy: ImageListViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        viewControllerSpy = ImageListViewControllerSpy()
    }
    
    override func tearDown() {
        viewControllerSpy = nil
        super.tearDown()
    }
    
    func testUpdateTableViewAnimatedCalled() {
        viewControllerSpy.updateTableViewAnimated(withPhotos: [])
        XCTAssertTrue(viewControllerSpy.updateTableViewAnimatedCalled)
    }
    
    func testShowLikeErrorCalled() {
        viewControllerSpy.showLikeError()
        XCTAssertTrue(viewControllerSpy.showLikeErrorCalled)
    }
}
