//
//  AppDelegate.swift
//  PutioAPI
//
//  Created by Altay Aydemir on 03/13/2019.
//  Copyright (c) 2019 Altay Aydemir. All rights reserved.
//

import UIKit
import PutioAPI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let api = PutioAPI(clientID: "", clientSecret: "")
        api.setToken(token: "")
        api.getFiles(parentID: 0, query: [:]) { (file, files, error) in
            print("parent", file as Any)
            print("children", files as Any)
            print("error", error as Any)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

