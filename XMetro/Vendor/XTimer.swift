//
//  XTimer.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/15.
//

import SwiftUI

class XTimer{
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
}
