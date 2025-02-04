//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 04.02.2025.
//

@testable import Image_Feed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var presenter: ProfilePresenterProtocol?
    weak var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var logoutCalled = false
    var performLogoutCalled = false
    var updateAvatarCalled = false
       
    var profileService: ProfileService = .shared
    var profileImageService: ProfileImageService = .shared
    var tokenStorage: OAuth2TokenStorage = .init()
   
    func viewDidLoad() {
       viewDidLoadCalled = true
    }
   
    func showSplashScreen() {
        // Можно оставить пустым, так как это тестовый заглушечный класс (Spy)
    }

    
    func logout() {
       logoutCalled = true
    }
   
    func performLogout() {
        performLogoutCalled = true
    }
   
    func updateAvatar() {
        updateAvatarCalled = true
    }
}
