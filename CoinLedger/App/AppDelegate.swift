//
//  AppDelegate.swift
//  CoinLedger
//
//  Created by GICHUKI on 26/04/2025.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = MainTabBarController()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    
    // MARK: - Core Data stack
    /// Reference the shared CoreDataManager
    let coreDataManager = CoreDataManager.shared
    
    // MARK: - Core Data Saving support
    func saveContext () {
        coreDataManager.saveContext()
    }
    
}

