//
//  TempoDotsView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/15.
//

import SwiftUI
import ComposableArchitecture

struct TempoDotsView: View {
    private let rows = 3
    private let columsPerRow = 4
    @Binding var countDownIndex: Int
    @Binding var runningIndex: Int
    @Binding var total: Int
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columsPerRow, id: \.self) { colum in
                        let index = Int(row * columsPerRow + colum)
                        Text("")
                            .frame(width: 10, height: 10, alignment: .center)
                            .background(dotColor(index))
                            .foregroundColor(Theme.whiteColor)
                            .cornerRadius(5.0)
                    }
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