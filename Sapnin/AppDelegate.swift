//
//  AppDelegate.swift
//  Sapnin
//
//  Created by Alan Lau on 25/03/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase configuration
        FirebaseApp.configure()
        
        // Facebook login configuration
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Remove border in navigation bar and change to white background, and also make icons (tint) pink
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().backgroundColor = UIColor.white
        UINavigationBar.appearance().tintColor = BrandColours.PINK
        
        // Change font colour, style and size of navigation bar title
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: BrandColours.NAV_TITLE_COLOUR, NSAttributedStringKey.font: UIFont(name: "Roboto-Regular", size: 22)!]
        
        // Set back button to icon
        let backImg = UIImage(named: "back_icon")
        UINavigationBar.appearance().backIndicatorImage = backImg
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImg
        
        // Remove the text "Back" from back button by moving it off the screen at -1000 offset
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -1000, vertical: 0), for: UIBarMetrics.default)
        
        // Set initial screen as login VC if the user hasn't logged in, or channel VC if the user is still logged in
        configureInitialViewController()
        
        return true
    }
    
    // If user's still logged in, then go directly to channel VC on app load, otherwise go to login VC
    func configureInitialViewController() {
        var initialVC: UIViewController
        if Auth.auth().currentUser != nil {
            let channelStoryboard = UIStoryboard(name: "Channel", bundle: nil)
            initialVC = channelStoryboard.instantiateViewController(withIdentifier: IDENTIFER_CHANNEL_NAV_CONTROLLER)
        } else {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            initialVC = mainStoryboard.instantiateViewController(withIdentifier: IDENTIFER_LOGIN_NAV_CONTROLLER)
        }
        
        window?.rootViewController = initialVC
        
        // Shows the window and makes it the key window.
        window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        // Facebook login configuration
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

