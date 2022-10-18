//
//  PushManager.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/18.
//

import Foundation

struct PushManager {
    static func didReceiveRemoteNotification(_ userInfo:  [AnyHashable : Any]) {
        // TODO: 跳转到AppStore下载页
        print(userInfo)
    }
}
