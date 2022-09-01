//
//  AppDelegate.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 17/07/2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestoreSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    let dbService = DbService()
//    static var firebaseApp: FirebaseAppProto = isTestRun() ? MockFirebaseApp() : FirebaseAppService()
//    static var favoriteRecipes: FavoriteRecipes! = {
//        if isTestRun() {
//            FavoriteRecipes.shared = FavoriteRecipes(idsDb: MockIdsDb())
//        }
//    }()
    
    static private func isTestRun() -> Bool {
        return NSClassFromString("XCTest") != nil
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if !Self.isTestRun() {
            FirebaseApp.configure()

            Task {
                try await FavoriteRecipes.shared.setIdsStore(IdsStore("favorites"))
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

