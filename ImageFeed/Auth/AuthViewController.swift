//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 25.09.2024.
//

import UIKit
import ProgressHUD

//прошла ли авторизация
protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let segueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?

    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    private var progressElement = UIBlockingProgressHUD()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //перехода не будет, если индикатор все еще виден
        guard !UIBlockingProgressHUD.isShowing else { return }
        
        if segue.identifier == segueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(segueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        print("Authenticated with code: \(code)")  // Для отладки
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }

            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):  // Получаем токен из результата
                ProfileService.shared.fetchProfile(token) { profileResult in
                    DispatchQueue.main.async {
                        switch profileResult {
                        case .success:
                            // Успешно получили профиль, вызываем делегат
                            self.delegate?.authViewController(self, didAuthenticateWithCode: code)
                        case .failure(let error):
                            print("Failed to fetch profile: \(error)")
                            // Показываем алерт с ошибкой
                            self.showErrorAlert(message: "Не удалось получить профиль пользователя.")
                        }
                    }
            }
            case .failure(let error):
                print("Failed to fetch OAuth token: \(error.localizedDescription)")
                // Показываем алерт с ошибкой
                self.showErrorAlert(message: "Не удалось получить профиль пользователя.")
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        guard !UIBlockingProgressHUD.isShowing else { return }
        dismiss(animated: true)
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor? = UIColor.black
    }
    
    // Функция для отображения алерта с ошибкой
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: message,
            preferredStyle: .alert
        )
            
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertController.addAction(okAction)
            
        present(alertController, animated: true, completion: nil)
    }
}
