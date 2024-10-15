//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 25.09.2024.
//

import UIKit

class AuthViewController: UIViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        let oauthService = OAuth2Service() // Создаём экземпляр сервиса

        oauthService.fetchOAuthToken(with: code) { result in
            switch result {
            case .success(let token):
                print("Successfully fetched token: \(token)")
                // Здесь можно обновить UI или выполнить дальнейшие действия, например, перейти на главный экран приложения

            case .failure(let error):
                print("Error fetching token: \(error)")
                // Обработка ошибку, например, показать алерт пользователю
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

