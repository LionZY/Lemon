//
//  TempoItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/13.
//

import Foundation
import SwiftUI

struct TempoItem: Equatable {
    static func == (lhs: TempoItem, rhs: TempoItem) -> Bool {
        return lhs.id == rhs.id
        && lhs.meter == rhs.meter
        && lhs.devide == rhs.devide
        && lhs.bpm == rhs.bpm
        && lhs.subDivision == rhs.subDivision
        && lhs.soundEffect == rhs.soundEffect
    }
    
    let id = "\(Date.now.timeIntervalSince1970)"
    
    var meter: Int {
        didSet { TempoItem.save(meter, forKey: TempoItem.KSaved_Meter) }
    }
    
    var devide: Int {
        didSet { TempoItem.save(devide, forKey: TempoItem.KSaved_Devide) }
    }

    var bpm: Int {
        didSet { TempoItem.save(bpm, forKey: TempoItem.KSaved_BPM) }
    }
    
    var subDivision: String {
        didSet { TempoItem.save(subDivision, forKey: TempoItem.KSaved_Subdivision) }
    }
    
    var soundEffect: String {
        didSet { TempoItem.save(soundEffect, forKey: TempoItem.KSaved_Subdivision) }
    }
    
    init() {
        self.meter = TempoItem.meter
        self.devide = TempoItem.devide
        self.bpm = TempoItem.bpm
        self.subDivision = TempoItem.subdivision
        self.soundEffect = TempoItem.soundEffect
    }
}

extension TempoItem {
    static let KSaved_BPM = "KSaved_BPM"
    static let KSaved_Meter = "KSaved_Meter"
    static let KSaved_Devide = "KSaved_Devide"
    static let KSaved_Subdivision = "KSaved_Subdivision"
    static let KSaved_SoundEffect = "KSaved_SoundEffect"
    
    static var meter: Int {
        let meter = UserDefaults.standard.integer(forKey: KSaved_Meter)
        return meter == 0 ? 4 : meter
    }
    
    static var devide: Int {
        let devide = UserDefaults.standard.integer(forKey: KSaved_Devide)
        return devide == 0 ? 4 : devide
    }
    
    static var bpm: Int {
        let bpm = UserDefaults.standard.integer(forKey: KSaved_BPM)
        return bpm == 0 ? 60 : bpm
    }
    
    static var subdivision: String {
        guard let subdivision = UserDefaults.standard.string(forKey: KSaved_Subdivision) else { return "♩" }
        return subdivision
    }
    
    static var soundEffect: String {
        guard let soundEffect = UserDefaults.standard.string(forKey: KSaved_SoundEffect) else { return "" }
        return soundEffect
    }
    
    static func save(_ value: Any, forKey: String) {
        let ud = UserDefaults.standard
        ud.set(value, forKey: forKey)
        ud.synchronize()
    }
}
