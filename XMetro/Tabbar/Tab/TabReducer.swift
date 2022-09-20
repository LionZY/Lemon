//
//  TabReducer.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import ComposableArchitecture

var selectedTabItemReducer: ViewStore<TabItemState, TabItemAction>? {
    willSet {
        selectedTabItemReducer?.send(.normal)
        guard let index = selectedTabItemReducer?.state.index else { return }
        selectedTabContentReducer?.send(.hide(index))
    }
    
    didSet {
        selectedTabItemReducer?.send(.selected)
        guard let index = selectedTabItemReducer?.state.index else { return }
        selectedTabContentReducer?.send(.show(index))
    }
}

var selectedTabContentReducer: ViewStore<TapContentState, TapContentAction>?

let tabReducer = Reducer<TabState, TabAction, TabEnv> { state, action, env in
    return .none
}.debug()
