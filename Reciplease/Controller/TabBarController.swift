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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
