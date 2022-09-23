//
//  MetroActionButtonState.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/8.
//

import Foundation

let KSaved_BPM = "KSaved_BPM"
let KSaved_Meter = "KSaved_Meter"

struct MetroActionButtonState: Equatable {
    static func == (lhs: MetroActionButtonState, rhs: MetroActionButtonState) -> Bool {
        return lhs.count == rhs.count && lhs.bpm == rhs.bpm && lhs.currentIndex == rhs.currentIndex && lhs.isCountDown == rhs.isCountDown
    }
    
    static var startIndex = -4
    var count: Int = 4 {
        didSet {
            let ud = UserDefaults.standard
            ud.set(count, forKey: KSaved_Meter)
            ud.synchronize()
        }
    }

    var bpm: Int = 60 {
        didSet {
            let ud = UserDefaults.standard
            ud.set(bpm, forKey: KSaved_BPM)
            ud.synchronize()
        }
    }

    var currentIndex = MetroActionButtonState.startIndex
    var currentAction: MetroActionButtonAction = .stop
    var title: String {
        if isCountDown {
            return "\(abs(currentIndex))"
        }
        return ""
    }
    
    var titleIcon: String {
        if isCountDown { return "" }
        return currentAction == .stop ? "play.fill" : "stop.fill"
    }
    
    var isCountDown: Bool {
        currentIndex < 0 && currentAction != .stop
    }
    
    mutating func jump() {
        if currentIndex < 0 {
            currentIndex = currentIndex + 1
        } else {
            currentIndex = (currentIndex + 1) % count
        }
    }
}
