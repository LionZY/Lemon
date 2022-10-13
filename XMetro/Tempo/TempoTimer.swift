//
//  TempoTimer.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/13.
//

import Foundation

var timer = Timer.publish(every: 4.0/4.0, on: .main, in: .common).autoconnect()

func createNewTimer(timerEvery: Double) {
    timer = Timer.publish(every: timerEvery, on: .main, in: .common).autoconnect()
}

func cancelTimer() {
    timer.upstream.connect().cancel()
}
