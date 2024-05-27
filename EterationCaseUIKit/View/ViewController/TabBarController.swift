//  TabBarViewController.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 25.05.2024.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initilazeView()
        tabBar.backgroundColor = UIColor.white
    }
    
    private func initilazeView() {
        let homeVC = HomeViewController()
        let cartVC = CartViewController()
        let favoriteVC = FavoriteViewController()
        let profileVC = ProfileViewController()
        
        let homeNavController = UINavigationController(rootViewController: homeVC)
        let cartNavController = UINavigationController(rootViewController: cartVC)
        let favoriteNavController = UINavigationController(rootViewController: favoriteVC)
        let profileNavController = UINavigationController(rootViewController: profileVC)
        
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: nil)
        cartVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "cart"), selectedImage: nil)
        favoriteVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "star"), selectedImage: nil)
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        
        viewControllers = [homeNavController, cartNavController, favoriteNavController, profileNavController]
    }
}
