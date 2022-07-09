//
//  BoredButtonReducer.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/8.
//

import Foundation
import Combine
import ComposableArchitecture
import AVFAudio

var audioPlayer:AVAudioPlayer?
func createPlayerIfNeeded() {
    if audioPlayer == nil {
        let path = Bundle.main.path(forResource: "dot", ofType: "m4a")!
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer =  try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            // can't load file
        }
    }
}

func destroy() {
    audioPlayer?.stop()
    audioPlayer = nil
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
        }
        state.jump()
        if state.isCountDown { return .none }
        audioPlayer?.play()
        break
    case .stop:
        state.currentAction = .stop
        state.currentIndex = BoredButtonState.startIndex
        timer.upstream.connect().cancel()
        audioPlayer?.stop()
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
