//
//  CafeTabBarController.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/7/12.
//

import UIKit
import SideMenu

class CafeTabBarController: UITabBarController {
    
    let myColor = Colors.shared
    let customButton = UIButton()
    
    var cafeListVC : UINavigationController!
    var studyVC : UINavigationController!
    var gatherVC : UINavigationController!
    var businessVC : UINavigationController!
    
    var sideMenu : SideMenuNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = myColor.primaryColor
        self.tabBar.tintColor = myColor.secondaryColor
        self.tabBar.unselectedItemTintColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // this line need
    }
}
