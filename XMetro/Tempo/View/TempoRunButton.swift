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
        case .row: return .custom("Charter-BoldItalic", size: 32)
        case .global: return .custom("Charter-BoldItalic", size: 32)
        }
    }
    
    func normalFont() -> Font {
        switch self {
        case .row: return Font.system(size: 18)
        case .global: return Font.system(size: 18)
        }
    }
    
    func font(isCountingDown: Bool) -> Font {
        isCountingDown ? countDownFont() : normalFont()
    }
    
    func runColor() -> Color {
        switch self {
        case .row: return Theme.redColor
        case .global: return Theme.whiteColorA95
        }
    }
    
    func stopedColor() -> Color {
        switch self {
        case .row: return Theme.blackColor
        case .global: return Theme.whiteColorA95
        }
    }
    
    func countDownColor() -> Color {
        switch self {
        case .row: return Theme.yellowColor
        case .global: return Theme.whiteColorA95
        }
    }
    
    func frontColor() -> Color {
        switch self {
        case .row: return Theme.whiteColor
        case .global: return Theme.redColor
        }
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
        if isRunning { return style.runColor() }
        if isStoped { return style.stopedColor() }
        if manager.isCountDownEnable { return style.countDownColor() }
        return Theme.blackColor
    }

    var body: some View {
        ZStack {
            if icon.count > 0 { Image(systemName: icon) }
            if (title.count > 0) { Text(title) }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color.cornerRadius(8.0))
        .foregroundColor(style.frontColor())
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
        .animation(.easeInOut, value: countDownIndex)
    }
    
    private func updateKey() -> String {
        "\(style)_\(tempo.uid)"
    }
}
