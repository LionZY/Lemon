//
//  TempoRunManager.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/18.
//

import SwiftUI

class TempoRunManager {
    
    // Data Model
    var tempoItem: TempoModel = .init()
    
    // Timer
    private var timer: TGCDTimer?
    private var countDownTimer: TGCDTimer?
    
    // Index
    var runingIndex: Int = -1
    var countDownIndex: Int = -4
    
    // Status
    var isCountDown: Bool { countDownIndex < 0 && countDownIndex > -4 }
    var isReadyCountDown: Bool { countDownIndex == -4 }
    var isCountDownStoped: Bool { countDownIndex == 0 }
    var isRunning: Bool { countDownIndex > -4 }
    var action: TempoScreenAction { isReadyCountDown ? .run : .stop }
    var timerEvery: CGFloat { countDownIndex == -4 ? 1.0 : (60.0 / CGFloat(tempoItem.bpm)) }
    var shouldPlayStrong: Bool { runingIndex == 0 }
    var isCountDownEnable: Bool { MetronomeSettingsListItem.countDownEnable() }
    
    // Actions
    func coundDown() {
        if isReadyCountDown {
            AudioManager.beginRemoteControlEvent()
            XTimer.shared.createNewTimer(timerEvery: isCountDownEnable ? timerEvery : 0) {
                self.countDownHandler()
            }
        }
    }
    
    func stop() {
        XTimer.shared.cancelTimer()
        PlayerManager.stopPlayers()
        countDownIndex = -4
        runingIndex = -1
        notifyListeners()
    }
    
    func run() {
        XTimer.shared.cancelTimer()
        PlayerManager.CreateAndPlayStrong(manager: self)
        runingIndex = (runingIndex + 1) % tempoItem.meter
        notifyListeners()
        XTimer.shared.createNewTimer(timerEvery: timerEvery) {
            self.runHandler()
        }
    }
    
    func countDownHandler() {
        if countDownIndex < 0 { countDownIndex = countDownIndex + 1 }
        if isCountDownStoped { run() }
        notifyListeners()
    }
    
    func runHandler() {
        runingIndex = (runingIndex + 1) % tempoItem.meter
        PlayerManager.Play(strong: shouldPlayStrong)
        notifyListeners()
    }
    
    func nextAction() {
        if action == .run {
            stop()
            coundDown()
        }
    
        if action == .stop {
            stop()
        }
    }
    
    // MARK: -
    private var liseners: [AnyHashable: (() -> Void)] = [:]
    func notifyListeners() {
        liseners.forEach({ key, callback in
            callback()
        })
    }
    
    func register(key: String, callback: @escaping (() -> Void)) {
        liseners[key] = callback
    }
    
    func remove(key: String) {
        liseners.removeValue(forKey: key)
    }
}
