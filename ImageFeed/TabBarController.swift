//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 20.11.2024.
//

import UIKit
 
final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabBarController loaded")
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
                       title: "",
                       image: UIImage(named: "tab_profile_active"),
                       selectedImage: nil
                   )
        
        imagesListViewController.tabBarItem = UITabBarItem(
                       title: "",
                       image: UIImage(named: "tab_editorial_active"),
                       selectedImage: nil
                   )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
