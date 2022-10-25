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
        case .row: return 3
        case .global: return 3
        }
    }
    
    func colums() -> Int {
        switch self {
        case .row: return 4
        case .global: return 4
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .row: return CGSize(width: 6, height: 6)
        case .global: return CGSize(width: 6, height: 6)
        }
    }
    
    func radius() -> CGFloat {
        switch self {
        case .row: return 3.0
        case .global: return 3.0
        }
    }
}


struct TempoDotsView: View {
    @Binding var manager: TempoRunManager
    @State private var updateKey = "\(TempoDotsView.self)"
    @State private var countDownIndex = -4
    @State private var runningIndex = -1
    @State private var total = 4
    @State var tempo: TempoModel
    var style: TempoDotsStyle = .global
    var body: some View {
        VStack(spacing: 5.0) {
            dots()
        }
        .onAppear {
            updateKey = "\(TempoDotsView.self)_\(style)_\(tempo.uid)"
            total = tempo.meter
            
            let rowCallback = {
                guard manager.tempoItem.uid == tempo.uid else { return }
                countDownIndex = manager.countDownIndex
                runningIndex = manager.runingIndex
                total = manager.tempoItem.meter
            }
            
            let globalCallback = {
                tempo = manager.tempoItem
                countDownIndex = manager.countDownIndex
                runningIndex = manager.runingIndex
                total = manager.tempoItem.meter
            }
            let callback = style == .global ? globalCallback : rowCallback
            manager.register(key: updateKey, callback: callback)
        }
    }
    
    @ViewBuilder private func dots() -> some View {
        let rows = style.rows()
        let colums = style.colums()
        let size = style.size()
        let radius = style.radius()
        ForEach(0..<rows, id: \.self) { row in
            HStack(spacing: 5.0) {
                ForEach(0..<colums, id: \.self) { colum in
                    let index = Int(row * colums + colum)
                    Text("")
                        .frame(width: size.width, height: size.height, alignment: .center)
                        .background(dotColor(index))
                        .foregroundColor(Theme.whiteColor)
                        .cornerRadius(radius)
                }
            }
        }
    }

    func dotColor(_ dotIndex: Int) -> Color {
        guard dotIndex < total else { return Color(.systemGray5) }
        guard runningIndex == dotIndex else { return Theme.mainColor }
        return Theme.lightColor
    }
}
