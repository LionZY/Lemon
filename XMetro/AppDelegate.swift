//
//  AppDelegate.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import UIKit
import MediaPlayer
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UMOC.config()
        UMOC.registerPush(application, launchOptions: launchOptions, delegate: self)
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let trigger = response.notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self) {
            UMessage.didReceiveRemoteNotification(userInfo)
            PushManager.didReceiveRemoteNotification(userInfo)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(UMOC.deviceTokenStr(deviceToken))
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        AudioManager.endRemoteControlEvent()
    }
}
