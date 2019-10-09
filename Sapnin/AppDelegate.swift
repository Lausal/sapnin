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
import UserNotifications
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // Notification variables
    let gcmMessageIDKey = "gcm.message_id"
    static var isToken: String? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SVProgressHUD.setDefaultMaskType(.black)
        // Firebase configuration
        FirebaseApp.configure()
        
        // Change tab bar colour to pink
        UITabBar.appearance().tintColor = BrandColours.PINK
        
        // Remove border in navigation bar and change to white background
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        // Set all header/navigation bar items to be pink
        UINavigationBar.appearance().tintColor = BrandColours.BAR_BUTTON_ITEM_COLOUR
        
        // Set disabled bar button item colour to faded pink
        let disabledButtonAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: BrandColours.DISABLED_BUTTON_PINK]
        UIBarButtonItem.appearance().setTitleTextAttributes(disabledButtonAttribute, for: .disabled)
        
        // Change font colour, style and size of navigation bar title
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: BrandColours.NAV_TITLE_COLOUR, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 20)!]
        
        // Set back button to icon
        let backImg = UIImage(named: "back_icon")
        UINavigationBar.appearance().backIndicatorImage = backImg
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImg
        
        // Remove the text "Back" from back button by moving it off the screen at -1000 offset
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -1000, vertical: 0), for: UIBarMetrics.default)
        
        // Set initial screen as login VC if the user hasn't logged in, or channel VC if the user is still logged in
        configureInitialViewController()
        
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.sound, .badge, .alert] // Types of notifications we want to use
            
            // Request authorisation to show notifications
            current.requestAuthorization(options: options) { (granted, error) in
                if error != nil {
                    
                } else {
                    Messaging.messaging().delegate = self
                    current.delegate = self
                    
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                    
                    // Store to user DB on Firebase
                    self.storeTokenToUserDB()
                }
            }
        } else {
            let types: UIUserNotificationType = [.sound, .badge, .alert]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
            // Store to user DB on Firebase
            self.storeTokenToUserDB()
        }
        
        // Configuration to retrieve token ID for push notification
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                AppDelegate.isToken = result.token
            }
            
        }
        
        // Configuration for Facebook login - when user clicks "Sign in with FB", we switch to the FB app to for the user to type in their credentials
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    // Stores the token ID to the corresponding user database on Firebase
    func storeTokenToUserDB() {
        // Grab the token
        guard let token = AppDelegate.isToken else {
            return
        }
        
        let dict = ["tokenID": token]
        Api.User.DB_REF_CURRENT_USER?.updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil {
                //onError(error!.localizedDescription)
            } else {
                //onSuccess()
            }
        })
    }
    
    // If user's still logged in, then go directly to channel VC on app load, otherwise go to login VC
    func configureInitialViewController() {
        var initialVC: UIViewController
        if Auth.auth().currentUser != nil && UserDefaults.standard.bool(forKey: LAUNCHED_ONCE){
            let channelStoryboard = UIStoryboard(name: "Channel", bundle: nil)
            initialVC = channelStoryboard.instantiateViewController(withIdentifier: IDENTIFIER_TABBAR)
        } else {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            initialVC = mainStoryboard.instantiateViewController(withIdentifier: IDENTIFER_LOGIN_NAV_CONTROLLER)
            UserDefaults.standard.set(true, forKey: LAUNCHED_ONCE)
        }
        
        window?.rootViewController = initialVC
        
        // Shows the window and makes it the key window.
        window?.makeKeyAndVisible()
    }
    
    // Handles URL opened for different login types
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled = false
        
        if url.absoluteString.contains("fb") {
            // Handles FaceBook URL
            handled = ApplicationDelegate.shared.application(app, open: url, options: options)
        } else {
            // Handles other URL (I.e. Google)
        }
        
        return handled
    }
    
    //    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    //
    //        // Facebook login configuration
    //        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    //    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        Messaging.messaging().shouldEstablishDirectChannel = false
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFirebase()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Handles push notification received whilst app is in background
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if let messageId = userInfo[gcmMessageIDKey] {
            print("messageId: \(messageId)")
        }
        
        print(userInfo)
    }
    
    // Function called when user taps on notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("messageID: \(messageID)")
        }
        
        connectToFirebase()
        // Use this to track message delivery and analytics for messages
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Notify that the new data was successfully downloaded
        completionHandler(.newData)
    }
    
    // Called if can't register for push
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // Tell app that its successfully registered for Apple push notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let token = AppDelegate.isToken else {
            return
        }
        print("token: \(token)")
        
    }
    
    // To tell that Firebase will automatically establish a socket based direct channel to the fcm server
    func connectToFirebase() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    
}

// Methods to handle a push notifation
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    @available(iOS 10.0, *)
    
    // Handle push notification when app is running in foreground - i.e. if we receive a notification whilst app is open, and we tap on it, then this method will be called.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Extract notification content and assign to userInfo variable
        let userInfo = notification.request.content.userInfo
        
        if let message = userInfo[gcmMessageIDKey] {
            print("Message: \(message)")
        }
        print(userInfo)
        
        completionHandler([.sound, .badge, .alert])
        
    }
    
    // Called when token is available or has been refreshed. This is normally available when the device has been successfully registered for push - typically called once per app start.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        guard let token = AppDelegate.isToken else {
            return
        }
        print("Token123: \(token)")
        connectToFirebase()
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Remote message: \(remoteMessage.appData)")
    }
    
}
