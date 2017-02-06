//
//  AppDelegate.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/19/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import Archeota
import AromaSwiftClient
import Kingfisher
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static internal let buildNumber: String = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        LOG.level = .debug
        LOG.enable()
        
        AromaClient.TOKEN_ID = "34576d0b-6060-4666-9ac1-f5a09be219c3"
        
        AromaClient.beginMessage(withTitle: "App Launched")
            .addBody("Build #\(AppDelegate.buildNumber)")
            .withPriority(.low)
            .send()
        
        NSSetUncaughtExceptionHandler() { error in
            
            AromaClient.beginMessage(withTitle: "App Crashed")
                .addBody("On Device: \(UIDevice.current.name)")
                .addLine(2)
                .addBody("\(error)")
                .withPriority(.high)
                .send()
            
            LOG.error("Uncaught Exception: \(error)")
        }
        
        ImageCache.default.maxDiskCacheSize = UInt(150.mb)
        ImageCache.default.maxCachePeriodInSecond = (3.0).days
        
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        AromaClient.sendLowPriorityMessage(withTitle: "App Entered Background")
        ImageCache.default.clearMemoryCache()
        ImageCache.default.cleanExpiredDiskCache()
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        AromaClient.sendMediumPriorityMessage(withTitle: "App Terminated")
            
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        
        AromaClient.beginMessage(withTitle: "Memory Warning")
            .withPriority(.medium)
            .addBody("Build #\(AppDelegate.buildNumber)")
            .send()
        ImageCache.default.clearMemoryCache()
        
    }

}

