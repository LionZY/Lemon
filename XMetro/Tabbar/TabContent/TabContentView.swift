//
//  TabContentView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

struct TabContentView: View {
    private let metronomeScreen = MetronomeScreen()
    private let tunerScreen = TunerScreen()
    private let settingsScreen = SettingsScreen()
    let store = Store(initialState: TapContentState(selectIndex: 0), reducer: contentReducer, environment: TapContentEnv())
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                switch viewStore.state.selectIndex {
                case 0: metronomeScreen.background(.white)
                case 1: tunerScreen.background(.white)
                default: settingsScreen.background(.white)
                }
            }.onAppear {
                selectedTabContentReducer = viewStore
            }
        }
    }
}

struct TabContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabContentView()
    }
}
