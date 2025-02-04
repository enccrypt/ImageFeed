//
//  WebViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 04.02.2025.
//

import Image_Feed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var presenter: Image_Feed.WebViewPresenterProtocol?
    
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        // оставлю пустым, тесты не проверяют этот метод?
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        return abs(value - 1.0) <= 0.0001
    }
    
    func shouldAuthenticate(for url: URL) -> String? {
        return code(from: url)
    }

    
    func code(from url: URL) -> String? {
        return nil
    }
}
