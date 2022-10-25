//
//  XAudioPlayer.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/13.
//

import Foundation
import AVFAudio

struct PlayerManager {
    static var lightPlayer:AVAudioPlayer?
    static func createLightPlayerIfNeeded(manager: TempoRunManager? = nil) {
        if lightPlayer == nil {
            let resource = manager?.tempoItem.soundEffect ?? "Default"
            guard let path = Bundle.main.path(forResource: resource, ofType: "m4a") else { return }
            let url = URL(fileURLWithPath: path)
            do {
                lightPlayer =  try AVAudioPlayer(contentsOf: url)
                lightPlayer?.prepareToPlay()
            } catch {
                // can't load file
            }
        }
    }

    static var strongPlayer:AVAudioPlayer?
    static func createStrongPlayerIfNeeded(manager: TempoRunManager? = nil) {
        if strongPlayer == nil {
            let resource = manager?.tempoItem.soundEffectStong ?? "Default_strong"
            guard let path = Bundle.main.path(forResource: resource, ofType: "m4a") else { return }
            let url = URL(fileURLWithPath: path)
            do {
                strongPlayer =  try AVAudioPlayer(contentsOf: url)
                strongPlayer?.prepareToPlay()
            } catch {
                // can't load file
            }
        }
    }

    static func createPlayers(manager: TempoRunManager? = nil) {
        createLightPlayerIfNeeded(manager: manager)
        createStrongPlayerIfNeeded(manager: manager)
    }

    static func stopPlayers() {
        strongPlayer?.stop()
        strongPlayer = nil
        lightPlayer?.stop()
        lightPlayer = nil
    }

    static func recreatePlayers(manager: TempoRunManager? = nil) {
        stopPlayers()
        createPlayers(manager: manager)
    }
    
    static func CreateAndPlayStrong(manager: TempoRunManager? = nil) {
        PlayerManager.createPlayers(manager: manager)
        PlayerManager.strongPlayer?.play()
    }
    
    static func Play(strong: Bool) {
        (strong ? strongPlayer : lightPlayer)?.play()
    }
}

struct AudioManager {
    static func beginAudionSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .mixWithOthers])
            try session.setActive(true)
        } catch (let e) {
            print(e.localizedDescription)
        }
    }
    
    static func endAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch (let e) {
            print(e.localizedDescription)
        }
    }
    
    static func beginRemoteControlEvent() {
        beginAudionSession()
        (UIApplication.shared.delegate as? AppDelegate)?.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    static func endRemoteControlEvent() {
        endAudioSession()
        (UIApplication.shared.delegate as? AppDelegate)?.resignFirstResponder()
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
}
