//
//  TempoDotsView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/15.
//

import SwiftUI
import ComposableArchitecture

enum TempoDotsStyle {
    case row
    case global
    
    func rows() -> Int {
        switch self {
        case .row: return 1
        case .global: return 1
        }
    }
    
    func colums() -> Int {
        switch self {
        case .row: return 12
        case .global: return 12
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .row: return CGSize(width: 4, height: 6)
        case .global: return CGSize(width: 4, height: 10)
        }
    }
    
    func hSpacing() -> CGFloat {
        switch self {
        case .row: return 4.0
        case .global: return 4.0
        }
    }
    
    func vSpacing() -> CGFloat {
        switch self {
        case .row: return 4.0
        case .global: return 4.0
        }
    }
    
    func radius() -> CGFloat {
        switch self {
        case .row: return 0.0
        case .global: return 0.0
        }
    }
    
    func normalColor() -> Color {
        switch self {
        case .row: return Theme.blackColor
        case .global: return Theme.whiteColor
        }
    }
    
    func runColor() -> Color {
        switch self {
        case .row: return Theme.redColor
        case .global: return Theme.whiteColor
        }
    }
    
    func disableColor() -> Color {
        switch self {
        case .row: return Theme.grayColorF1
        case .global: return Theme.whiteColorA2
        }
    }
}

struct TempoDotsView: View {
    @ObservedObject var manager: TempoRunManager
    @State private var updateKey = "\(TempoDotsView.self)"
    @State private var countDownIndex = -(TempoSettingsListItem.countDownTime() + 1)
    @State private var runningIndex = -1
    @State private var total = 4
    @State var tempoId: String
    var style: TempoDotsStyle = .global
    var body: some View {
        VStack(spacing: style.vSpacing()) {
            dots()
        }
        .onAppear {
            updateKey = "\(TempoDotsView.self)_\(style)_\(tempoId)"            
            let rowCallback = {
                guard manager.state.tempoItem.uid == tempoId else { return }
                countDownIndex = manager.countDownIndex
                runningIndex = manager.runingIndex
                total = manager.state.tempoItem.meter
            }
            
            let globalCallback = {
                tempoId = manager.state.tempoItem.uid
                countDownIndex = manager.countDownIndex
                runningIndex = manager.runingIndex
                total = manager.state.tempoItem.meter
            }
            let callback = style == .global ? globalCallback : rowCallback
            manager.register(key: updateKey, callback: callback)
        }
        .animation(.easeInOut, value: runningIndex)
    }
    
    @ViewBuilder private func dots() -> some View {
        let rows = style.rows()
        let colums = style.colums()
        let size = style.size()
        let radius = style.radius()
        ForEach(0..<rows, id: \.self) { row in
            HStack(alignment: .bottom, spacing: style.hSpacing()) {
                ForEach(0..<colums, id: \.self) { colum in
                    let index = Int(row * colums + colum)
                    Text("")
                        .frame(width: size.width, height: runningIndex == index ? 2 * size.height : size.height, alignment: .center)
                        .background(dotColor(index))
                        .foregroundColor(Theme.whiteColor)
                        .cornerRadius(radius)
                }
            }
        }
    }

    func dotColor(_ dotIndex: Int) -> Color {
        guard dotIndex < total else { return style.disableColor() }
        guard runningIndex == dotIndex else { return style.normalColor() }
        return style.runColor()
    }
}
