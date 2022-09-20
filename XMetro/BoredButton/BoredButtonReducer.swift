//
//  BoredButtonReducer.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/8.
//

import Foundation
import Combine
import ComposableArchitecture
import AVFAudio
import UIKit

var dotPlayer:AVAudioPlayer?
func createPlayerIfNeeded() {
    if dotPlayer == nil {
        let path = Bundle.main.path(forResource: "dot", ofType: "m4a")!
        let url = URL(fileURLWithPath: path)
        do {
            dotPlayer =  try AVAudioPlayer(contentsOf: url)
            dotPlayer?.prepareToPlay()
        } catch {
            // can't load file
        }
    }
}

var strongPlayer:AVAudioPlayer?
func createStrongPlayerIfNeeded() {
    if strongPlayer == nil {
        let path = Bundle.main.path(forResource: "dot_strong", ofType: "m4a")!
        let url = URL(fileURLWithPath: path)
        do {
            strongPlayer =  try AVAudioPlayer(contentsOf: url)
            strongPlayer?.prepareToPlay()
        } catch {
            // can't load file
        }
    }
}

func destroy() {
    strongPlayer?.stop()
    strongPlayer = nil
    dotPlayer?.stop()
    dotPlayer = nil
    timer.upstream.connect().cancel()
}

var timer = Timer.publish(every: 4.0/4.0, on: .main, in: .common).autoconnect()
let BoredButtonReducer = Reducer<BoredButtonState, BoredButtonAction, BoredButtonEnv> { state, action, _ in
    switch action {
    case .run:
        if state.currentAction != .run {
            state.currentAction = .run
            timer = Timer.publish(every: 60.0 / Double(state.bpm), on: .main, in: .common).autoconnect()
            createPlayerIfNeeded()
            createStrongPlayerIfNeeded()
            UIApplication.shared.isIdleTimerDisabled = true
        }
        state.jump()
        if state.isCountDown { return .none }
        if state.currentIndex == 0 {
            strongPlayer?.play()
        } else {
            dotPlayer?.play()
        }
        break
    case .stop:
        state.currentAction = .stop
        state.currentIndex = BoredButtonState.startIndex
        timer.upstream.connect().cancel()
        dotPlayer?.stop()
        strongPlayer?.stop()
        UIApplication.shared.isIdleTimerDisabled = false
        break
    case .updateBpm(let bpm):
        state.bpm = bpm
        break
    case .updateCount(let count):
        state.count = count
        break
    }
    return .none
}
