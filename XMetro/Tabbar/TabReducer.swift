//
//  TabReducer.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import ComposableArchitecture

let tabReducer = Reducer<TabState, TabAction, TabEnv> { state, action, env in
    switch action {
    case .select(let type):
        if state.current != type { state.current = type }
        break
    }
    return .none
}
