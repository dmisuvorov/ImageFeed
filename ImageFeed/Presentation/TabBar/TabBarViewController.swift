//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 18.02.2023.
//

import UIKit

final class TabBarViewController : UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let imagesListViewController = storyboard
            .instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
