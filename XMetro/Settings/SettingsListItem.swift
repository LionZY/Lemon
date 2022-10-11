//
//  SettingsListItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

enum SettingListItem: Hashable {
    case metronome
    case tuner
    case about
    
    func icon() -> String {
        switch self {
        case .metronome: return "metronome"
        case .tuner: return "tuningfork"
        case .about: return "info.circle"
        }
    }
    
    func title() -> String {
        switch self {
        case .metronome: return "Metronome settings"
        case .tuner: return "Tuner settings"
        case .about: return "About XMetro"
        }
    }
    
    func destination() -> some View {
        switch self {
        case .metronome: return AboutScreen()
        case .tuner: return AboutScreen()
        case .about: return AboutScreen()
        }
    }
}
