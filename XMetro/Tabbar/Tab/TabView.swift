//
//  TabView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

struct TabView: View {
    let store: Store<TabState, TabAction>
    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                VStack {
                    TabContentView()
                    HStack {
                        ForEach(viewStore.items, id: \.self) {
                            let itemStore = Store(initialState: $0, reducer: tabItemReducer, environment: TabItemEnv())
                            TabItemView(store: itemStore)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView(
            store: Store(
                initialState: TabState(),
                reducer: tabReducer,
                environment: TabEnv()
            )
        )
    }
}
