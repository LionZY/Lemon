//
//  ImageButton.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/9/23.
//

import SwiftUI
import ComposableArchitecture

struct TempoRunButton: View {
    @Binding var countDownIndex: Int
    private let startIcon: String = "play.fill"
    private let stopIcon: String = "stop.fill"
    
    private var icon: String {
        isRunning ? stopIcon : isStoped ? startIcon : ""
    }
    
    private var isStoped: Bool {
        countDownIndex == -4
    }
    
    private var isRunning: Bool {
        countDownIndex == 0
    }

    private var title: String {
        isRunning ? "" : isStoped ? "" : "\(abs(countDownIndex))"
    }
    
    private var color: Color {
        isRunning ? Theme.lightColor : isStoped ? Theme.mainColor : Theme.middleLightColor
    }

    var body: some View {
        ZStack {
            if icon.count > 0 {
                Image(systemName: icon)
            } else if (title.count > 0) {
                Text(title)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color)
        .foregroundColor(Theme.whiteColor)
    }
}
