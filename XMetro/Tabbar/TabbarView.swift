//
//  TabView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

struct TabbarView: View {
    let store: Store<TabState, TabAction> = Store(initialState: TabState(), reducer: tabReducer, environment: TabEnv())
    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                VStack(spacing: 0) {
                    viewStore.state.current.content()
                    HStack {
                        ForEach(viewStore.state.items, id: \.self) {
                            TabItemView(viewStore: viewStore, item: $0)
                        }
                    }
                    .background(Theme.whiteColor)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
