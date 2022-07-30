//
//  Helpers.swift
//  LeBaluchon
//
//  Created by Rodolphe Desruelles on 10/07/2022.
//

import UIKit

enum TabBarItemTag: Int {
    case search = 1
    case favorites = 2
}

class ControllerHelper {
    static func simpleAlert(message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertVC
    }
}
