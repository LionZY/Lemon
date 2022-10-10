//
//  XMetroApp.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI

@main
struct XMetroApp: App {
    init() {
        UMCommonSwift.initWithAppkey(appKey: "6343ddf288ccdf4b7e4574be", channel: "App Store")
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
