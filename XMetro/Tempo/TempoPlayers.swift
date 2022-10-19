//
//  XAudioPlayer.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/13.
//

import Foundation
import AVFAudio

var lightPlayer:AVAudioPlayer?
func createLightPlayerIfNeeded(manager: TempoRunManager? = nil) {
    if lightPlayer == nil {
        let resource = manager?.tempoItem.soundEffect ?? TempoItem.soundEffect
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

var strongPlayer:AVAudioPlayer?
func createStrongPlayerIfNeeded(manager: TempoRunManager? = nil) {
    if strongPlayer == nil {
        let resource = manager?.tempoItem.soundEffectStong ?? TempoItem.soundEffectStrong
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

func createPlayers(manager: TempoRunManager? = nil) {
    createLightPlayerIfNeeded(manager: manager)
    createStrongPlayerIfNeeded(manager: manager)
}

func stopPlayers() {
    lightPlayer?.stop()
    strongPlayer?.stop()
}

func cleanPlayers() {
    strongPlayer?.stop()
    strongPlayer = nil
    lightPlayer?.stop()
    lightPlayer = nil
}

func recreatePlayers(manager: TempoRunManager? = nil) {
    cleanPlayers()
    createPlayers(manager: manager)
}
