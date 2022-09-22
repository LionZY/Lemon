//
//  HomeView2.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

struct MetronomeScreen: View {
    var body: some View {
        MetroActionButton(store: Store(initialState: MetroActionButtonState(), reducer: MetroActionButtonReducer, environment: MetroActionButtonEnv()))
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .navigationTitle("Metronome")
            .tint(.black)
    }
}

struct MetronomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeScreen()
    }
}
