//
//  TempoViewState.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/8.
//

import ComposableArchitecture

struct TempoViewState: Equatable {
    var buttonTitle: String {
        isCountDown ? "\(abs(currentIndex))" : ""
    }
    
    var titleIcon: String {
        isCountDown ? "" : (currentAction == .stop ? "play.fill" : "stop.fill")
    }
    
    var isCountDown: Bool {
        currentIndex < 0 && currentAction != .stop
    }
    
    var timerEvery: Double {
        60.0 / Double(tempoItem.bpm)
    }
    
    var timeScale: Int {
        Int(1.0 / timerEvery)
    }
    
    var shouldJumpCurrentIndex: Bool {
        timeScale <= 0 || (timeScale > 0 && countDownIndex % timeScale == 0)
    }
    
    var shouldPlayStrong: Bool {
        currentIndex == 0
    }
    
    var shouldPlayLight: Bool {
        currentIndex != 0
    }

    static var startIndex = -4
    var tempoItem: TempoItem
    var countDownIndex = 0
    var currentIndex = TempoViewState.startIndex
    var currentAction: TempoViewAction = .stop
    
    init(
        tempoItem: TempoItem = .init(),
        countDownIndex: Int = 0,
        currentIndex: Int = TempoViewState.startIndex,
        currentAction: TempoViewAction = .stop
    ) {
        self.tempoItem = tempoItem
        self.countDownIndex = countDownIndex
        self.currentIndex = currentIndex
        self.currentAction = currentAction
    }
    
    mutating func jumpCurrentIndex() {
        let next = currentIndex + 1
        currentIndex = currentIndex < 0 ? next : next % tempoItem.meter
    }
    
    mutating func jumpCountDownIndex() {
        countDownIndex = countDownIndex + 1
    }
    
    mutating func resetCountDown() {
        countDownIndex = 0
    }
    
    mutating func reset() {
        currentAction = .stop
        currentIndex = TempoViewState.startIndex
    }
    
    static func == (lhs: TempoViewState, rhs: TempoViewState) -> Bool {
        return lhs.tempoItem == rhs.tempoItem
        && lhs.currentIndex == rhs.currentIndex
        && lhs.isCountDown == rhs.isCountDown
    }
}
