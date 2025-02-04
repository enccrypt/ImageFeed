//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 04.02.2025.
//

import Image_Feed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
       var presenter: WebViewPresenterProtocol?
       var loadRequestCalled: Bool = false
       
       func load(request: URLRequest) {
           loadRequestCalled = true
       }
       
       func setProgressValue(_ newValue: Float) { }
       func setProgressHidden(_ isHidden: Bool) { }
}
