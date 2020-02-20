//
//  AppDelegate.swift
//  GFN-GameList
//
//  Created by nicolas le flohic on 11/02/2020.
//  Copyright © 2020 nicolas le flohic. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        print (Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        let config = Realm.Configuration(shouldCompactOnLaunch: { totalBytes, usedBytes in
            // totalBytes refers to the size of the file on disk in bytes (data + free space)
            // usedBytes refers to the number of bytes used by data in the file

            // Compact if the file is over 10MB in size and less than 50% 'used'
            let oneHundredMB = 10 * 1024 * 1024
            print ("used : \(usedBytes) total : \(totalBytes)")
            let exceed = (totalBytes > oneHundredMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
            print (exceed)
            return exceed
        })
        Realm.Configuration.defaultConfiguration = config

        do {
            print ("launch realm")
            let _ = try Realm(configuration: config)
        } catch {
            print (error.localizedDescription)
        }

        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

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



