//
//  TabItemView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

struct TabItemView: View {
    let viewStore: ViewStore<TabState, TabAction>
    let item: TabbarItemType
    var body: some View {
        VStack {
            Image(systemName: item.icon())
                .frame(height: 20.0, alignment: .center)
            Spacer()
                .frame(maxHeight: 4.0)
            Text(item.title())
                .font(.system(size: 12))
        }
        .frame(maxWidth: .infinity, maxHeight: 44.0)
        .foregroundColor(viewStore.current == item ? Theme.lightColor : Theme.mainColor)
        .onTapGesture {
            viewStore.send(.select(item))
        }
    }
}
