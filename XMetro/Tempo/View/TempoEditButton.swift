//
//  TempoActionButton.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/11/2.
//

import SwiftUI

enum TempoEditAction: String {
    case none
    case timeSignature
    case bpm
    case soundEffect
    case duration
    
    static func allCases() -> [TempoEditAction] {
        [.timeSignature, .bpm, .soundEffect]
    }
    
    static func uiCases() -> [TempoEditAction] {
        [.timeSignature, .none, .bpm, .none, .soundEffect, .none, .duration]
    }
    
    func title(manager: TempoRunManager) -> String {
        switch self {
        case .timeSignature: return "\(manager.state.tempoItem.meter)/\(manager.state.tempoItem.devide)"
        case .bpm: return "\(manager.state.tempoItem.bpm)"
        case .soundEffect: return manager.state.tempoItem.soundEffect
        case .duration: return manager.state.tempoItem.duration
        default: return ""
        }
    }
    
    func popCase() -> PopType {
        switch self {
        case .timeSignature: return .timeSignature
        case .bpm: return .bpm
        case .soundEffect: return .sound
        case .duration: return .duration
        case .none: return .none
        }
    }
    
    func width() -> CGFloat {
        switch self {
        case .timeSignature: return UIDevice.isPhone() ? 48.0 : 88.0
        case .bpm: return UIDevice.isPhone() ? 48.0 : 88.0
        case .soundEffect: return .infinity
        case .duration: return UIDevice.isPhone() ? 48.0 : .infinity
        case .none: return 44.0
        }
    }
}

struct TempoEditButton: View {
    var manager: TempoRunManager
    @State private var title: String = ""
    var type: TempoEditAction
    var body: some View {
        Button {
            manager.state.tempoItemBeforeEdit = manager.state.tempoItem
            manager.tabbar?.pop(type: type.popCase(), value: true)
            manager.notifyListeners()
        } label: {
            Text(title)
                .frame(maxWidth: type.width(), maxHeight: Theme.miniButtonHeight)
                .font(.system(size: 12))
                .background(Theme.whiteColorA2.cornerRadius(8.0))
                .foregroundColor(Theme.whiteColor)
        }
        .onAppear {
            title = type.title(manager: manager)
            manager.register(key: "\(TempoEditButton.self)_\(type)") {
                title = type.title(manager: manager)
            }
        }
        .animation(.easeInOut, value: title)
    }
}
