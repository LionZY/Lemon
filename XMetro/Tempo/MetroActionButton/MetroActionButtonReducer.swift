//
//  MetroActionButtonReducer.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/8.
//

import Foundation
import Combine
import ComposableArchitecture

let MetroActionButtonReducer = Reducer<MetroActionButtonState, MetroActionButtonAction, MetroActionButtonEnv> { state, action, _ in
    switch action {
    case .run:
        if state.currentAction != .run {
            state.currentAction = .run
            createNewTimer(timerEvery: state.timerEvery)
            createPlayers()
        }
        if state.isCountDown {
            if state.shouldJumpCurrentIndex { state.jumpCurrentIndex() }
            state.jumpCountDownIndex()
            if state.shouldPlayStrong { strongPlayer?.play() }
        } else {
            state.resetCountDown()
            state.jumpCurrentIndex()
            if state.shouldPlayStrong { strongPlayer?.play() }
            if state.shouldPlayLight { lightPlayer?.play() }
        }
        break
    case .stop:
        state.reset()
        cancelTimer()
        stopPlayers()
        break
    case .updateBpm(let bpm):
        state.tempoItem.bpm = bpm
        break
    case .updateTimeSignature(let meter, let devide):
        state.tempoItem.meter = meter
        state.tempoItem.devide = devide
        break
    }
    return .none
}
