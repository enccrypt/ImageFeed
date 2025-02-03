//
//  ImageListViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Kaider on 02.02.2025.
//

@testable import Image_Feed
import Foundation

final class ImageListViewControllerSpy: ImageListViewControllerProtocol {
    var updateTableViewAnimatedCalled = false
    var showLikeErrorCalled = false
    
    func updateTableViewAnimated(withPhotos photos: [Photo]) {
        updateTableViewAnimatedCalled = true
    }
    
    func showLikeError() {
        showLikeErrorCalled = true
    }
}
