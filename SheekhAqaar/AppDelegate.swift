//
//  AppDelegate.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AlamofireNetworkActivityIndicator
import Localize_Swift
import Material
import SwiftyUserDefaults
import DropDown
import OneSignal
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    public static var instance: AppDelegate!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppDelegate.instance = self
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.2
        NetworkActivityIndicatorManager.shared.completionDelay = 0.5
        
        IQKeyboardManager.shared.enable = true
        DropDown.startListeningToKeyboard()

        let appStarter = ApplicationStarter()
        appStarter.startApplication(window: window)
        handlePushNotification(launchOptions: launchOptions)
        return true
    }
    
    func handlePushNotification(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
            let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
            
            let _ : OSHandleNotificationReceivedBlock = { notification in
                
                print("Received Notification: \(notification!.payload.notificationID)")
                print("launchURL = \(notification?.payload.launchURL ?? "None")")
                print("content_available = \(notification?.payload.contentAvailable ?? false)")
            }
            
            let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
                // This block gets called when the user reacts to a notification received
                let payload: OSNotificationPayload? = result?.notification.payload
                
                if let additionalData = result!.notification.payload!.additionalData {
                    print("additionalData = \(additionalData)")
                    if let notificationType = additionalData["NotificationType"] as? Dictionary<String, Any> {
                        if let type = notificationType["Id"] as? Int {
                            if let targetId = additionalData["TargetId"] as? Int {
                                
                                let navigationController = UINavigationController()
                                self.window?.rootViewController = navigationController
                                
    //                            switch type {
    //                            case 1: // chat
    //                                let storyboard = UIStoryboard(name: "Inbox", bundle: nil)
    //                                let messagesVC = storyboard.instantiateViewController(withIdentifier: "messagesViewControllerSideMenu") as! messagesViewController
    //                                navigationController.pushViewController(messagesVC, animated: true)
    //
    //                                let chatVC = storyboard.instantiateViewController(withIdentifier: "chatViewController") as! chatViewController
    //                                chatVC.id_chat = targetId
    //                                navigationController.pushViewController(chatVC, animated: true)
    //                                break
    //
    //                            case 2: // upcoming
    //                                let storyboard = UIStoryboard(name: "Reservations", bundle: nil)
    //                                let reservationsVC = storyboard.instantiateViewController(withIdentifier: "Reserv") as! ReservationsVC
    //                                navigationController.pushViewController(reservationsVC, animated: true)
    //                                break
    //
    //                            case 3: // video
    //
    //                                let storyboard = UIStoryboard(name: "Video", bundle: nil)
    //                                let vc = storyboard.instantiateViewController(withIdentifier: "IncomingCallVC") as! IncomingCallVC
    //                                vc.id_booking = targetId
    //
    //                                navigationController.pushViewController(vc, animated: true)
    //                                break
    //
    //                            default:
    //                                break
    //                            }
                            }
                        }
                    }
                }
            }
            
            // Replace 'YOUR_APP_ID' with your OneSignal App ID.
            OneSignal.initWithLaunchOptions(launchOptions,
                                            appId: "5006efdf-899e-4189-9239-42b7d3eea882",
                                            handleNotificationAction: notificationOpenedBlock,
                                            settings: onesignalInitSettings)
            
            OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
            
            // Recommend moving the below line to prompt for push after informing the user about
            //   how your app will use them.
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                print("User accepted notifications: \(accepted)")
            })
            
            OneSignal.add(self as OSSubscriptionObserver)
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

extension AppDelegate: OSSubscriptionObserver {
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.pushToken {
//            AppDelegate.playerId = playerId
//            UserDefaults.standard.set(playerId, forKey: "playerId")
//            if let userData = AppDelegate.user {
//                print("Current playerId \(playerId)")
//
//                let params :[String:Any] = [
//                    "token":AppDelegate.user?.token ?? "",
//                    "first_name_en":AppDelegate.user?.first_name_en ?? "",
//                    "first_name_ar":AppDelegate.user?.first_name_ar ?? "",
//                    "last_name_en":AppDelegate.user?.last_name_en ?? "",
//                    "last_name_ar":AppDelegate.user?.last_name_ar ?? "",
//                    "phone":AppDelegate.user?.phone ?? "",
//                    "email":AppDelegate.user?.email ?? "",
//                    "birth_date":AppDelegate.user?.birth_date ?? "",
//                    "id_gender":AppDelegate.user?.id_gender ?? 0,
//                    "password":AppDelegate.user?.password ?? "",
//                    "OneSiganlToken" : AppDelegate.playerId ?? "",
//                    "version" : AppDelegate.appVersion ?? "",
//                    "mobileOS" : "ios",
//                    "id" : AppDelegate.user?.id ?? 0
//                ]
//
//                UserFunctionalModel.updateProfile(image: nil, params: params) { (user) in
//                    AppDelegate.user = user
//                }
//            }
            
        }
    }
}


