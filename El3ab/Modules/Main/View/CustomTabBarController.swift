//
//  CustomTabBarController.swift
//  El3ab
//
//  Created by Osama Khaled on 04/06/2026.
//

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor(red: 0.0, green: 0.541, blue: 0.239, alpha: 1.0)
        
        tabBar.unselectedItemTintColor = UIColor.lightGray
        
   
    }
}
