//
//  MetronomeSettingsListItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

enum TempoSettingsListItem: String, Hashable {
    
    case sortByBMP
    case countDownEnable
    
    var rawValue: String {
        switch self {
        case .sortByBMP: return "K_Settings_SortByBMP"
        case .countDownEnable: return "K_Settings_CountDownEnable"
        }
    }
    
    func icon() -> String {
        switch self {
        case .sortByBMP: return "dot.squareshape"
        case .countDownEnable: return "timer"
        }
    }
    
    func title() -> String {
        switch self {
        case .sortByBMP: return "Sort by BPM"
        case .countDownEnable: return "Countdown enable"
        }
    }
    
    func value() -> Bool {
        let ud = UserDefaults.standard
        let key = self.rawValue
        let value = ud.bool(forKey: key)
        return value
    }
    
    func save(newValue: Bool) {
        let ud = UserDefaults.standard
        let key = self.rawValue
        ud.set(newValue, forKey: key)
        ud.synchronize()
    }
    
    static func countDownEnable() -> Bool {
        TempoSettingsListItem.countDownEnable.value()
    }
    
    static func sortByBPM() -> Bool {
        TempoSettingsListItem.sortByBMP.value()
    }
    
    static func saveSortByBPM(newValue: Bool) {
        TempoSettingsListItem.sortByBMP.save(newValue: newValue)
    }
    
    static func saveCountDownEnable(newValue: Bool) {
        TempoSettingsListItem.countDownEnable.save(newValue: newValue)
    }
    
    static func createDefaultConfigs() {
        let ud = UserDefaults.standard
        let key = "K_FirstLaunch_Tempo"
        let firstLaunchFlag = ud.string(forKey: key)
        var item = TempoSettingsListItem.sortByBMP
        if firstLaunchFlag == nil { item.save(newValue: true) }
        item = TempoSettingsListItem.countDownEnable
        if firstLaunchFlag == nil { item.save(newValue: true) }
        if firstLaunchFlag == nil { ud.set("1", forKey: key) }
        ud.synchronize()
    }
}

