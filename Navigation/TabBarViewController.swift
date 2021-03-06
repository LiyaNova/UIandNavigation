//
//  TabBarViewController.swift
//  Navigation
//
//  Created by Юлия Филимонова on 04.04.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    let firstVC = LogInViewController()
    let secondVC = FeedViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.blueTheme
        setUpControllers()
    }

    private func setUpControllers() {
        let navControllerOne = UINavigationController(rootViewController: firstVC)
        firstVC.tabBarItem.title = "Profile"
        firstVC.tabBarItem.image = UIImage(systemName: "person.fill")
        
        let navControllerTwo = UINavigationController(rootViewController: secondVC)
        secondVC.tabBarItem.image = UIImage(systemName: "house.fill")
        secondVC.tabBarItem.title = "Feed"
      
        viewControllers = [navControllerTwo, navControllerOne]
    }
    
}
