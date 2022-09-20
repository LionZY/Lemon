//
//  ContentView.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    var body: some View {
        TabView(
            store: Store(
                initialState: TabState(),
                reducer: tabReducer,
                environment: TabEnv()
            )
        )
            .frame(maxWidth: .infinity, minHeight: 44.0)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
