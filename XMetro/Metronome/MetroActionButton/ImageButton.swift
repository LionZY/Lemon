//
//  ImageButton.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/9/23.
//

import SwiftUI
import ComposableArchitecture

struct ImageButton: View {
    let viewStore: ViewStore<MetroActionButtonState, MetroActionButtonAction>
    var body: some View {
        ZStack {
            Image(systemName: viewStore.state.titleIcon)
                .frame(width: 60, height: 60)
            Text(viewStore.state.title)
        }
    }
}
