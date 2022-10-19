//
//  PushManager.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/18.
//

import Foundation

struct PushManager {
    static func didReceiveRemoteNotification(_ userInfo:  [AnyHashable : Any]) {
        if let appId = userInfo["upgrade"] {
            let urlStr = "https://apps.apple.com/app/\(appId)"
            if let url = URL(string: urlStr) {
                UIApplication.shared.open(url)
            }
        }
    }
}
