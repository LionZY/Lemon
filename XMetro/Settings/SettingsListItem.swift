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
        case .about: return "About Ticker"
        }
    }
    
    @ViewBuilder func destination() -> some View {
        switch self {
        case .metronome: MetronomeSettingsScreen()
        case .tuner: TunerSettingsScreen()
        case .about: AboutScreen()
        }
    }
    
    func itemView() -> some View {
        NavigationLink(destination: destination()) {
            HStack{
                Image(systemName: icon())
                Text(title())
            }
        }
    }
}
