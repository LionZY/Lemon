//
//  TunerSettingsItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

enum TunerSettingsListItem: String, Hashable {
    case autoTuning
    
    func icon() -> String {
        switch self {
        case .autoTuning: return "tuningfork"
        }
    }
    
    func title() -> String {
        switch self {
        case .autoTuning: return "Automatic tuning"
        }
    }
    
    func value() -> Bool {
        let ud = UserDefaults.standard
        if ud.object(forKey: self.rawValue) != nil {
            return ud.bool(forKey: self.rawValue)
        }
        return true
    }
    
    func save(newValue: Bool) {
        let ud = UserDefaults.standard
        ud.set(newValue, forKey: self.rawValue)
        ud.synchronize()
    }
    
    static func autoTuner() -> Bool {
        TunerSettingsListItem.autoTuning.value()
    }
}

