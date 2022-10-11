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
        MetroActionButton(store: store)
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .navigationTitle("Metronome")
            .tint(Theme.mainColor)
            .onAppear(perform: {
                UIApplication.shared.isIdleTimerDisabled = true
            })
    }
}

struct MetronomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeScreen()
    }
}
