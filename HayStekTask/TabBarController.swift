//
//  TabBarController.swift
//  HayStekTask
//
//  Created by Geethansh  on 03/04/25.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        self.tabBar.tintColor = UIColor(named: "Green")
        self.tabBar.unselectedItemTintColor = UIColor.gray
    }
}
