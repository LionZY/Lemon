//
//  ImageButton.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/9/23.
//

import SwiftUI
import ComposableArchitecture

enum TempoPlayAction: Equatable {
    case run
    case stop
}

enum RunButtonStyle {
    case row
    case global
    
    func countDownFont() -> Font {
        switch self {
        case .row: return Font.system(size: 32)
        case .global: return Font.system(size: 24.0)
        }
    }
    
    func normalFont() -> Font {
        switch self {
        case .row: return Font.system(size: 14)
        case .global: return Font.system(size: 14)
        }
    }
    
    func font(isCountingDown: Bool) -> Font {
        isCountingDown ? countDownFont() : normalFont()
    }
}

struct TempoRunButton: View {
    @Binding var manager: TempoRunManager
    @State var tempo: TempoModel
    var style: RunButtonStyle = .row
    
    @State private var countDownIndex: Int = -4
    @State private var isCountingDown: Bool = false
    private let startIcon: String = "play.fill"
    private let stopIcon: String = "stop.fill"
    private var icon: String {
        if isRunning { return stopIcon }
        if isStoped { return startIcon }
        return ""
    }
    private var isStoped: Bool { countDownIndex == -4 }
    private var isRunning: Bool { countDownIndex == 0 }
    private var title: String {
        if isRunning || isStoped || !manager.isCountDownEnable { return "" }
        return "\(abs(countDownIndex))"
    }
    private var color: Color {
        if isRunning { return Theme.lightColor }
        if isStoped { return Theme.mainColor }
        if manager.isCountDownEnable { return Theme.middleLightColor }
        return Theme.mainColor
    }

    var body: some View {
        ZStack {
            if icon.count > 0 { Image(systemName: icon) }
            if (title.count > 0) { Text(title) }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color)
        .foregroundColor(Theme.whiteColor)
        .font(style.font(isCountingDown: isCountingDown))
        .onAppear {
            let rowCallback = {
                guard manager.tempoItem.uid == tempo.uid else { return }
                countDownIndex = manager.countDownIndex
                isCountingDown = manager.isCountDown
            }
            
            let globalCallback = {
                tempo = manager.tempoItem
                countDownIndex = manager.countDownIndex
                isCountingDown = manager.isCountDown
            }
            let callback = style == .global ? globalCallback : rowCallback
            manager.register(key: updateKey(), callback: callback)
        }
    }
    
    private func updateKey() -> String {
        "\(style)_\(tempo.uid)"
    }
}
