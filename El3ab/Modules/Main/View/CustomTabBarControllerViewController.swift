//
//  CustomTabBarControllerViewController.swift
//  El3ab
//
//  Created by Osama Khaled on 04/06/2026.
//

import UIKit

class CustomTabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBar.tintColor = UIColor(red: 0.0, green: 0.541, blue: 0.239, alpha: 1.0)
           // Set unselected item color (white/light gray)
        tabBar.unselectedItemTintColor = UIColor.lightGray
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
