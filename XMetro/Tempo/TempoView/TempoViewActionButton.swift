//
//  ImageButton.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/9/23.
//

import SwiftUI
import ComposableArchitecture

struct TempoViewActionButton: View {
    let viewStore: ViewStore<TempoViewState, TempoViewAction>
    var body: some View {
        ZStack {
            if let systemName = viewStore.state.titleIcon, systemName.count > 0 {
                Image(systemName: systemName)
            }
            Text(viewStore.state.buttonTitle)
        }
    }
}
