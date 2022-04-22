//
//  AppDelegate.swift
//  TODOApp
//
//  Created by Kaito on 2022/04/14.
//

import UIKit
import RealmSwift
import UserNotifications
import os

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 通知許可の取得
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]){
                (granted, _) in
                if granted{
                    UNUserNotificationCenter.current().delegate = self
                }
            }
        
        let config = Realm.Configuration(
                schemaVersion: 5,
                
                migrationBlock: { migration, oldSchemaVersion in
                    if(oldSchemaVersion < 1) {
                    }
               })
        Realm.Configuration.defaultConfiguration = config
        let realm = try!Realm()
        print(realm)
        print(config, "Realm Version")
        return true
    }
    
 
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}



