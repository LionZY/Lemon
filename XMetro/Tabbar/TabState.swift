//
//  TabState.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

let tempoScreen = TempoScreen()
let tunerScreen = TunerScreen()
let libraryScreen = LibraryScreen()
let settingsScreen = SettingsScreen()

enum PopupType {
    case timeSignature
    case bpm
    case subdivision
    case soundEffect
}

enum TabbarItemType: Int {
    case tempo
    case tuner
    case library
    case settings
    
    func icon() -> String {
        switch self {
        case .tempo: return "metronome"
        case .tuner: return "tuningfork"
        case .library: return "music.note.list"
        case .settings: return "gear"
        }
    }
    
    func title() -> String {
        switch self {
        case .tempo: return "Tempo"
        case .tuner: return "Tuner"
        case .library: return "Library"
        case .settings: return "Settings"
        }
    }
    
    @ViewBuilder func content() -> some View {
        switch self {
        case .tempo: tempoScreen
        case .tuner: tunerScreen
        case .library: libraryScreen
        case .settings: settingsScreen
        }
    }
}

struct TabState: Equatable {
    var current: TabbarItemType = .tempo
    var items: [TabbarItemType] = [.tempo, .tuner, .library, .settings]
}
