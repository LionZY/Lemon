//
//  TempoRunManager.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/18.
//

import SwiftUI

class TempoRunManager: ObservableObject {
    
    // Timer
    private var timer: TGCDTimer? = nil
    private var countDownTimer: TGCDTimer? = nil
    private var countDownTime: Int {
        TempoSettingsListItem.countDownTime() + 1
    }
    
    // State
    var state: TempoScreenState = .init()
    var tabbar: TabbarView?
    
    // Index
    var runingIndex: Int = -1
    var countDownIndex: Int = -(TempoSettingsListItem.countDownTime() + 1)
    
    // Run status
    var isCountDown: Bool { countDownIndex < 0 && countDownIndex > -countDownTime }
    var isReadyCountDown: Bool { countDownIndex == -countDownTime }
    var isCountDownStoped: Bool { countDownIndex == 0 }
    var isRunning: Bool { countDownIndex > -countDownTime }
    var action: TempoPlayAction { isReadyCountDown ? .run : .stop }
    var timerEvery: CGFloat { countDownIndex == -countDownTime ? 1.0 : (60.0 / CGFloat(state.tempoItem.bpm)) }
    var shouldPlayStrong: Bool { runingIndex == 0 }
    var isCountDownEnable: Bool { TempoSettingsListItem.countDownEnable() }
    
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
        countDownIndex = -countDownTime
        runingIndex = -1
        notifyListeners()
    }
    
    func run() {
        XTimer.shared.cancelTimer()
        PlayerManager.CreateAndPlayStrong(manager: self)
        runingIndex = (runingIndex + 1) % state.tempoItem.meter
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
        runingIndex = (runingIndex + 1) % state.tempoItem.meter
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
