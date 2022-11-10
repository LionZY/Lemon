//
//  XTimer.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/15.
//

import SwiftUI

class XTimer {
    private var durationTimer: TGCDTimer?
    private var timer: TGCDTimer?
    static let shared = XTimer()
    var timerEvery: Double = 1.0
    
    func createNewTimer(timerEvery: Double, block: @escaping () -> Void) {
        timer = TGCDTimer(timeInterval: timerEvery, repeat: true, block: block)
    }

    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func createDurationTimer(timerEvery: Double, block: @escaping () -> Void)  {
        durationTimer = TGCDTimer(timeInterval: timerEvery, repeat: false, block: block)
    }
    
    func cancelDurationTimer() {
        durationTimer?.invalidate()
        durationTimer = nil
    }
}
