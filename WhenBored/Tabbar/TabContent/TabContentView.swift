//
//  TabContentView.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

struct TabContentView: View {
    
    let store = Store(initialState: TapContentState(selectIndex: 0), reducer: contentReducer, environment: TapContentEnv())
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                if viewStore.state.selectIndex == 0 {
                    MetronomeScreen()
                } else if (viewStore.state.selectIndex == 1) {
                    TunerScreen()
                } else {
                    SettingsScreen()
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
