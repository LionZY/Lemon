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
        VStack(spacing: 0) {
            Spacer().frame(height: 10.0)
            Image(systemName: item.icon()).frame(height: 18.0)
            Spacer().frame(height: 2.0)
            Text(item.title()).font(.system(size: 12))
            Spacer().frame(height: 6.0)
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(viewStore.current == item ? Theme.redColor : Theme.blackColor)
        .onTapGesture {
            viewStore.send(.select(item))
        }
    }
}
