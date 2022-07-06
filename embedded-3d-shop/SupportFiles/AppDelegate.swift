//
//  AppDelegate.swift
//  embedded-3d-shop
//
//  Created by Андрей Груненков on 06.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        let rootVC = ProductsCollectionViewController()
        rootVC.view.backgroundColor = .white
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }

}

