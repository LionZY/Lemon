//
//  BoredButtonState.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/8.
//

import Foundation

struct BoredButtonState: Equatable {
    static func == (lhs: BoredButtonState, rhs: BoredButtonState) -> Bool {
        return lhs.count == rhs.count && lhs.bpm == rhs.bpm && lhs.currentIndex == rhs.currentIndex && lhs.isCountDown == rhs.isCountDown
    }
    
    static var startIndex = -4
    var count = 4
    var bpm = 60
    var currentIndex = BoredButtonState.startIndex
    var currentAction: BoredButtonAction = .stop
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
