//
//  HomeView2.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

struct TempoScreen: View {
    let store = Store<TempoViewState, TempoViewAction>(
        initialState: TempoViewState(),
        reducer: TempoViewReducer,
        environment: TempoViewEnv()
    )
    var body: some View {
        VStack {
            TempoView(store: store)
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .tint(Theme.mainColor)
        }
        .navigationTitle("Tempo")
    }
}

struct TempoScreen_Previews: PreviewProvider {
    static var previews: some View {
        TempoScreen()
    }
}
