//
//  BoardButtonState.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/8.
//

import Foundation

struct BoardButtonState: Equatable, Hashable {
    static var startIndex = -4
    var count = 4
    var bpm = 60
    var currentIndex = BoardButtonState.startIndex
    var currentAction: BoardButtonAction = .stop
    var title: String {
        if isCountDown {
            return "\(abs(currentIndex))"
        }
        return currentAction == .stop ? "Start" : "Stop"
    }
    
    var isCountDown: Bool {
        currentIndex < 0 && currentAction != .stop
    }
    
    mutating func jump() {
        if currentIndex < 0 {
            currentIndex = currentIndex + 1
        } else {
            currentIndex = (currentIndex + 1) % 4
        }
    }
}
