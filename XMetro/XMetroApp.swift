//
//  XMetroApp.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI

@main
struct XMetroApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        TunerSettingsListItem.createDefaultConfigs()
        TempoSettingsListItem.createDefaultConfigs()
        Theme.barButtonItemColors()
        CreateTables()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
