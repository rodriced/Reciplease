//
//  RecipeDirectionsViewController.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 30/07/2022.
//

import UIKit
import WebKit

class RecipeDirectionsViewController: UIViewController, WKUIDelegate {
    var directionsUrl: URL!
    var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let myRequest = URLRequest(url: directionsUrl)
        webView.load(myRequest)
//        webView.backgroundColor = UIColor(named: "BackgroundColor")
        navigationController?.navigationBar.backgroundColor = UIColor(named: "BackgroundColor")
        tabBarController?.tabBar.barTintColor = UIColor(named: "BackgroundColor")
    }
}
