//
//  AppDelegate.swift
//  RecipeRecommend
//
//  Created by 安高慎也 on 2016/02/08.
//  Copyright © 2016年 shinya adaka. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.setApplicationId("0y5Nmx1QnsisOFoEN3a40LPDXx2TjaDzbVV7VQPc", clientKey: "kKea2VUDpFETkVyrhnCutID0xg0odaVKbPFvCHd4")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        //インターネット接続確認
        if CheckReachability("google.com") {
        } else {
            let alertController = UIAlertController(title: "インターネット接続エラー", message: "本アプリは\nインターネットに接続した状態で\nご使用下さい", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        }
        //
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //バックグラウンド処理完了の通知を受け取る(AppDelegateファイルに記載)
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        NSLog("Background OK")
        print("終わり")
        completionHandler()
    }
}

