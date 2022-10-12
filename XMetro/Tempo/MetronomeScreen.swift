//
//  HomeView2.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

struct MetronomeScreen: View {
    let store = Store(initialState: MetroActionButtonState(), reducer: MetroActionButtonReducer, environment: MetroActionButtonEnv())
    var body: some View {
        ZStack {
            MetroActionButton(store: store)
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .tint(Theme.mainColor)
        }
        .navigationTitle("Tempo")
    }
}

struct MetronomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeScreen()
    }
}
