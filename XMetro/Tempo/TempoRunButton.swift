//
//  ImageButton.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/9/23.
//

import SwiftUI
import ComposableArchitecture

enum RunButtonStyle {
    case normal
    case large
    
    func countDownFont() -> Font {
        switch self {
        case .normal: return Font.system(size: 32)
        case .large: return Font.custom("Arial-BoldMT", size: 84)
        }
    }
    
    func normalFont() -> Font {
        switch self {
        case .normal: return Font.system(size: 14)
        case .large: return Font.system(size: 40)
        }
    }
    
    func font(isCountingDown: Bool) -> Font {
        isCountingDown ? countDownFont() : normalFont()
    }
}

struct TempoRunButton: View {
    @Binding var manager: TempoRunManager
    var tempo: TempoItem
    var style: RunButtonStyle = .normal
    
    @State private var countDownIndex: Int = -4
    @State private var isCountingDown: Bool = false
    private let startIcon: String = "play.fill"
    private let stopIcon: String = "stop.fill"
    private var icon: String { isRunning ? stopIcon : isStoped ? startIcon : "" }
    private var isStoped: Bool { countDownIndex == -4 }
    private var isRunning: Bool { countDownIndex == 0 }
    private var title: String { isRunning ? "" : isStoped ? "" : "\(abs(countDownIndex))" }
    private var color: Color { isRunning ? Theme.lightColor : isStoped ? Theme.mainColor : Theme.middleLightColor }

    var body: some View {
        ZStack {
            if icon.count > 0 { Image(systemName: icon) }
            if (title.count > 0) { Text(title) }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color)
        .foregroundColor(Theme.whiteColor)
        .font(style.font(isCountingDown: isCountingDown))
        .onAppear { register() }
        .onDisappear { remove() }
    }
    
    private func updateKey() -> String {
        "\(tempo.id)"
    }
    
    func register() {
        manager.register(key: updateKey()) {
            if manager.tempoItem.id == tempo.id {
                countDownIndex = manager.countDownIndex
                isCountingDown = manager.isCountDown
            }
        }
    }
    
    func remove() {
        manager.remove(key: updateKey())
    }
}
