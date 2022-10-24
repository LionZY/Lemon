//
//  TempoDotsView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/15.
//

import SwiftUI
import ComposableArchitecture

enum TempoDotsStyle {
    case small
    case normal
    
    func rows() -> Int {
        switch self {
        case .small: return 2
        case .normal: return 3
        }
    }
    
    func colums() -> Int {
        switch self {
        case .small: return 6
        case .normal: return 4
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .small: return CGSize(width: 6, height: 6)
        case .normal: return CGSize(width: 10, height: 10)
        }
    }
    
    func radius() -> CGFloat {
        switch self {
        case .small: return 3.0
        case .normal: return 5.0
        }
    }
}


struct TempoDotsView: View {
    @Binding var manager: TempoRunManager
    @State private var updateKey = "\(TempoDotsView.self)"
    @State private var countDownIndex = -4
    @State private var runningIndex = -1
    @State private var total = TempoModel.meter
    
    var type: TempoDotsStyle = .normal
    var tempo: TempoModel?
    
    var body: some View {
        VStack {
            dots()
        }
        .onAppear {
            updateKey = "\(TempoDotsView.self)_\(tempo?.uid ?? "")"
            total = tempo?.meter ?? TempoModel.meter
            manager.register(key: updateKey) {
                guard manager.tempoItem.uid == tempo?.uid || tempo?.uid == nil else { return }
                countDownIndex = manager.countDownIndex
                runningIndex = manager.runingIndex
                total = manager.tempoItem.meter
            }
        }
    }
    
    @ViewBuilder private func dots() -> some View {
        let rows = type.rows()
        let colums = type.colums()
        let size = type.size()
        let radius = type.radius()
        ForEach(0..<rows, id: \.self) { row in
            HStack() {
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
