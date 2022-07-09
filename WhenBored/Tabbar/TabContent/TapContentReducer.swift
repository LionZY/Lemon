//
//  TapContentReducer.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import ComposableArchitecture

let contentReducer = Reducer<TapContentState, TapContentAction, TapContentEnv> { state, action, _ in
    switch action {
    case .hide(let index):
        break
    case .show(let index):
        state.selectIndex = index
        break
    }
    return .none
}
