//
//  WebViewPresenter.swift
//  Image Feed
//
//  Created by Kaider on 02.02.2025
//

import Foundation

// MARK: - WebViewPresenterProtocol

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
    func shouldAuthenticate(for url: URL) -> String?
    func shouldHideProgress(for value: Float) -> Bool
}

// MARK: - WebViewPresenter

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewViewControllerProtocol?
    
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        // убрал создание urlComponents
        
        guard let request = authHelper.authRequest() else { return }
                
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func shouldAuthenticate(for url: URL) -> String? {
        return code(from: url)
    }

    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
          authHelper.code(from: url)
    }
}
