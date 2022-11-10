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
    case countDownTime
    
    var rawValue: String {
        switch self {
        case .sortByBMP: return "K_Settings_SortByBMP"
        case .countDownEnable: return "K_Settings_CountDownEnable"
        case .countDownTime: return "K_Settings_CountDownTime"
        }
    }
    
    func icon() -> String {
        switch self {
        case .sortByBMP: return "dot.squareshape"
        case .countDownEnable: return "timer"
        case .countDownTime: return "clock"
        }
    }
    
    func title() -> String {
        switch self {
        case .sortByBMP: return "Sort by BPM"
        case .countDownEnable: return "Enable"
        case .countDownTime: return "Duration"
        }
    }
    
    func value() -> Any? {
        let ud = UserDefaults.standard
        let key = self.rawValue
        let value = ud.object(forKey: key)
        return value
    }
    
    func save(newValue: Any) {
        let ud = UserDefaults.standard
        let key = self.rawValue
        ud.set(newValue, forKey: key)
        ud.synchronize()
    }
        
    static func countDownEnable() -> Bool {
        TempoSettingsListItem.countDownEnable.value() as? Bool ?? false
    }
    
    static func countDownTime() -> Int {
        TempoSettingsListItem.countDownTime.value() as? Int ?? 3
    }
    
    static func sortByBPM() -> Bool {
        TempoSettingsListItem.sortByBMP.value() as? Bool ?? false
    }
    
    static func saveSortByBPM(newValue: Bool) {
        TempoSettingsListItem.sortByBMP.save(newValue: newValue)
    }
    
    static func saveCountDownEnable(newValue: Bool) {
        TempoSettingsListItem.countDownEnable.save(newValue: newValue)
    }
    
    static func saveCountDownTime(newValue: Int) {
        TempoSettingsListItem.countDownTime.save(newValue: newValue)
    }
    
    static func createDefaultConfigs() {
        let ud = UserDefaults.standard
        let key = "K_FirstLaunch_Tempo"
        let firstLaunchFlag = ud.string(forKey: key)
        
        var item = TempoSettingsListItem.sortByBMP
        if firstLaunchFlag == nil { item.save(newValue: true) }
        
        item = TempoSettingsListItem.countDownEnable
        if firstLaunchFlag == nil { item.save(newValue: true) }
        
        item = TempoSettingsListItem.countDownTime
        if firstLaunchFlag == nil { item.save(newValue: "3") }
        
        if firstLaunchFlag == nil { ud.set("1", forKey: key) }
        ud.synchronize()
    }
}

