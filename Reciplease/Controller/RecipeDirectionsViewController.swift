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
