//
//  ProfilePresenter.swift
//  Image Feed
//
//  Created by Kaider on 12.11.2024.
//

import Foundation
import WebKit

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    let profileService: ProfileService
    let profileImageService: ProfileImageService
    let tokenStorage: OAuth2TokenStorage
    
    init(profileService: ProfileService = .shared,
         profileImageService: ProfileImageService = .shared,
         tokenStorage: OAuth2TokenStorage = .init()) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.tokenStorage = tokenStorage
    }
    
    func viewDidLoad() {
        updateProfile()
    }
    
    func showSplashScreen() {
        view?.showSplashScreen()
    }

    func logout() {
        view?.showLogoutAlert()
    }
    
    func performLogout() {
        tokenStorage.token = nil
        
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(
                    ofTypes: record.dataTypes,
                    for: [record],
                    completionHandler: {}
                )
            }
        }
        
        view?.showSplashScreen()

    }
    
    func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        view?.updateAvatar(url: url)
    }
    
    private func updateProfile() {
        guard let token = tokenStorage.token else { return }
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.view?.updateProfileDetails(profile: profile)
                    self.updateAvatar()
                case .failure(let error):
                    print("Ошибка получения профиля: \(error)")
                }
            }
        }
    }
}
