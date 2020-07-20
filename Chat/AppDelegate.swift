//
//  AppDelegate.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/8/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import UserNotifications
import NotificationBannerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var paths : [String] = []
    var dict : Dictionary =
        ["ListChat" : "ListChatViewController",
         "ChatDetails": "ChatViewController"
        ]
    //    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    //        if let error = error {
    //            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
    //                print("The user has not signed in before or they have since signed out.")
    //            } else {
    //                print("\(error.localizedDescription)")
    //            }
    //            return
    //        }
    //    }
    
    //    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
    //              withError error: Error!) {
    //        // Perform any operations when the user disconnects from app here.
    //        // ...
    //    }
    
    @available(iOS 9.0, *)
    internal func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if(launchOptions != nil){
            print("launch from others")
            
        }
        else{
            print("launch from touch icon app")
        }
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        FirebaseApp.configure()
        
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
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: Channel.PUSH_TOKEN), object: token)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        print("remote push ")
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: Channel.REMOTE_PUSH), object: userInfo)
    }
    
    
}

