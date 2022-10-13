//
//  XAudioPlayer.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/13.
//

import Foundation
import AVFAudio

var lightPlayer:AVAudioPlayer?
func createLightPlayerIfNeeded() {
    if lightPlayer == nil {
        let path = Bundle.main.path(forResource: "dot", ofType: "m4a")!
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
func createStrongPlayerIfNeeded() {
    if strongPlayer == nil {
        let path = Bundle.main.path(forResource: "dot_strong", ofType: "m4a")!
        let url = URL(fileURLWithPath: path)
        do {
            strongPlayer =  try AVAudioPlayer(contentsOf: url)
            strongPlayer?.prepareToPlay()
        } catch {
            // can't load file
        }
    }
}

func createPlayers() {
    createLightPlayerIfNeeded()
    createStrongPlayerIfNeeded()
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
