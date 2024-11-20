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
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "Navigation"
        )
        
        let profileViewController = storyboard.instantiateViewController(
            withIdentifier: "ProfileViewController"
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
