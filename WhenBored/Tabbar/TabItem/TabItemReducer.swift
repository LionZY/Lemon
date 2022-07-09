//
//  TabItemReducer.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import ComposableArchitecture

let tabItemReducer = Reducer<TabItemState, TabItemAction, TabItemEnv> { state, action, _ in
    switch action {
    case .normal:
        state.select = false
    case .selected:
        state.select = true
    }
    return .none
}
