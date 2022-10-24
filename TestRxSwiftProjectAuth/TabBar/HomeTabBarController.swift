//
//  HomeTabBarController.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let profileViewController = UIStoryboard.profileVC else { return }
        let navigationController = UINavigationController(rootViewController: profileViewController)
        
        let serviceProvider = ServiceProvider()
        let reactor = TaskListViewReactor(provider: serviceProvider)
        guard let taskViewController = UIStoryboard.taskListVC else { return }
        taskViewController.reactor = reactor
        let secNavigationController = UINavigationController(rootViewController: taskViewController)
        
        viewControllers = [navigationController, secNavigationController]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let tabItems = tabBar.items else { return }
        tabItems[0].titlePositionAdjustment = UIOffset(horizontal: -25, vertical: 0)
        tabItems[1].titlePositionAdjustment = UIOffset(horizontal: 25, vertical: 0)
    }
}
