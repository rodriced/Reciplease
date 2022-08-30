//
//  TabBarController.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 30/08/2022.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let topline = CALayer()
        topline.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
//        topline.backgroundColor = UIColor(named: "DismissColor")!.cgColor
        topline.backgroundColor = UIColor.black.cgColor
        tabBar.layer.addSublayer(topline)
    }
}
