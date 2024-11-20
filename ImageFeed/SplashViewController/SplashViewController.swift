//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 15.10.2024.
//

import Foundation
import UIKit

struct OAuthTokenResponse: Decodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

struct OAuthErrorResponse: Decodable {
    let error: String
    let errorDescription: String
    
    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}


final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    
    // MARK: - Private Properties
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    
    private enum SplashViewControllerConstants {
        static let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    }
    
    // MARK: - Overrides Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SplashView appeared")
        
        guard let token = storage.token else {
            performSegue(withIdentifier: SplashViewControllerConstants.showAuthenticationScreenSegueIdentifier, sender: nil)
            return
        }
        
        fetchProfile(token)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SplashViewControllerConstants.showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(SplashViewControllerConstants.showAuthenticationScreenSegueIdentifier)")
                return
            }
            
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - AuthViewControllerDelegate
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    // MARK: - Private Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController else {
            fatalError("TabBarController not found in Main.storyboard")
        }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Fetch token error: \(error.localizedDescription)")
                    let alert = UIAlertController(
                        title: "Ошибка",
                        message: "Не удалось получить токен. Попробуйте снова.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    
    private func fetchProfile(_ token: String) {
        // Показ индикатора загрузки
        UIBlockingProgressHUD.show()
        
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            // Скрытие индикатора загрузки
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                // Вызываем метод fetchProfileImageURL
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { result in
                    switch result {
                    case .success(let avatarURL):
                        print("Avatar URL fetched successfully: \(avatarURL)")
                    case .failure(let error):
                        print("Failed to fetch avatar URL: \(error)")
                    }
                }
                
                // Переход к основному интерфейсу
                self.switchToTabBarController()
                
            case .failure:
                print("Failed to fetch profile")
                
                // Показываем ошибку пользователю
                let alert = UIAlertController(
                    title: "Error",
                    message: "Failed to load profile. Please try again.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
