//
//  TabItemView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

struct TabItemView: View {
    let store: Store<TabItemState, TabItemAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Image(systemName: viewStore.state.icon)
                    .frame(height: 20.0, alignment: .center)
                Spacer()
                    .frame(maxHeight: 4.0)
                Text(viewStore.state.title)
                    .font(.system(size: 12))
            }
            .frame(maxWidth: .infinity, maxHeight: 44.0)
            .foregroundColor(viewStore.state.select ? Theme.lightColor : Theme.mainColor)
            .onTapGesture {
                if selectedTabItemReducer?.state.index != viewStore.state.index { selectedTabItemReducer = viewStore }
            }
            .onAppear {
                guard selectedTabItemReducer == nil, viewStore.state.select == true else { return }
                selectedTabItemReducer = viewStore
            }
        }
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView(store: Store(
            initialState: TabItemState(icon: "person", title: "me", select: false, index: 0),
            reducer: tabItemReducer,
            environment: TabItemEnv()
        ))
    }
}
