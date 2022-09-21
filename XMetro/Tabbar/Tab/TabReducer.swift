//
//  TabReducer.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import ComposableArchitecture

var preTabItemReducer: ViewStore<TabItemState, TabItemAction>?
var selectedTabItemReducer: ViewStore<TabItemState, TabItemAction>? {
    willSet {
        preTabItemReducer = selectedTabItemReducer
        preTabContentReducer = selectedTabContentReducer
    }
    
    didSet {
        preTabItemReducer?.send(.normal)
        guard let index = preTabItemReducer?.state.index else { return }
        preTabContentReducer?.send(.hide(index))
        
        selectedTabItemReducer?.send(.selected)
        guard let index = selectedTabItemReducer?.state.index else { return }
        selectedTabContentReducer?.send(.show(index))
    }
}

var preTabContentReducer: ViewStore<TapContentState, TapContentAction>?
var selectedTabContentReducer: ViewStore<TapContentState, TapContentAction>?

let tabReducer = Reducer<TabState, TabAction, TabEnv> { state, action, env in
    return .none
}.debug()
