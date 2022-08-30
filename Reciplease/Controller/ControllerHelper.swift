//
//  ControllerHelpers.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 10/08/2022.
//

import SwiftUI
import UIKit

enum TabBarItemTag: Int {
    case search = 1
    case favorites = 2
}

enum ControllerHelper {
    static func simpleErrorAlert(message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertVC
    }

    static func addButtonActivityIndicator(to button: UIButton) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor.white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        button.addSubview(indicator)

        indicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        indicator.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -5).isActive = true
        indicator.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true

        return indicator
    }

    static func addTableViewActivityIndicator(to tableView: UITableView) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor.white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        tableView.addSubview(indicator)

        indicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        indicator.centerXAnchor.constraint(equalTo: tableView.frameLayoutGuide.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: tableView.frameLayoutGuide.centerYAnchor).isActive = true

        return indicator
    }

    static func addBottomGradient(to view: UIView) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        view.layer.addSublayer(gradient)
    }
}

extension String {
    var firstUppercased: String {
        guard let firstLetter = first?.uppercased() else { return self }
        return firstLetter + suffix(from: index(startIndex, offsetBy: 1))
    }
}
