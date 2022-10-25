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
        return ud.bool(forKey: self.rawValue)
    }
    
    func save(newValue: Bool) {
        let ud = UserDefaults.standard
        ud.set(newValue, forKey: self.rawValue)
        ud.synchronize()
    }
    
    static func countDownEnable() -> Bool {
        TempoSettingsListItem.countDownEnable.value()
    }
    
    static func sortByBPM() -> Bool {
        TempoSettingsListItem.sortByBMP.value()
    }
    
    static func createDefaultConfigs() {
        let ud = UserDefaults.standard
        
        var item = TempoSettingsListItem.sortByBMP
        var exists = ud.object(forKey: item.rawValue)
        if exists == nil { item.save(newValue: true) }
        
        item = TempoSettingsListItem.countDownEnable
        exists = ud.object(forKey: item.rawValue)
        if exists == nil { item.save(newValue: true) }
    }
}

