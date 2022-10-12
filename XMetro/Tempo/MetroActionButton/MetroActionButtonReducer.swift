//
//  MetroActionButtonReducer.swift
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
    countDownFlag = 0
    timer.upstream.connect().cancel()
}

var countDownFlag = 0
var timer = Timer.publish(every: 4.0/4.0, on: .main, in: .common).autoconnect()
let MetroActionButtonReducer = Reducer<MetroActionButtonState, MetroActionButtonAction, MetroActionButtonEnv> { state, action, _ in
    switch action {
    case .run:
        let every = 60.0 / Double(state.bpm)
        let scale = Int(1.0 / every)
        if state.currentAction != .run {
            state.currentAction = .run
            timer = Timer.publish(every: every, on: .main, in: .common).autoconnect()
            createPlayerIfNeeded()
            createStrongPlayerIfNeeded()
        }
        
        if state.isCountDown {
            if scale <= 0 || (scale > 0 && countDownFlag % scale == 0) { state.jump() }
            countDownFlag = countDownFlag + 1
            if state.currentIndex == 0 { strongPlayer?.play() }
        } else {
            countDownFlag = 0
            state.jump()
            (state.currentIndex == 0 ? strongPlayer : dotPlayer)?.play()
        }
        break
    case .stop:
        state.currentAction = .stop
        state.currentIndex = MetroActionButtonState.startIndex
        timer.upstream.connect().cancel()
        dotPlayer?.stop()
        strongPlayer?.stop()
        break
    case .updateBpm(let bpm):
        state.bpm = bpm
        break
    case .updateTimeSignature(let meter, let devide):
        state.meter = meter
        state.devide = devide
        break
    }
    return .none
}
