//
//  MetronomeSettingsListItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

enum MetronomeSettingsListItem: String, Hashable {
    
    case autoSaveTimeSignature
    case autoSaveBPM
    case countDownEnable
    
    func icon() -> String {
        switch self {
        case .autoSaveTimeSignature: return "dot.squareshape"
        case .autoSaveBPM: return "note"
        case .countDownEnable: return "timer"
        }
    }
    
    func title() -> String {
        switch self {
        case .autoSaveTimeSignature: return "Auto save time signature"
        case .autoSaveBPM: return "Auto save bpm"
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
        MetronomeSettingsListItem.countDownEnable.value()
    }
}

