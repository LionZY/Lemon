//
//  TempoItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/13.
//

import Foundation

struct TempoItem: Equatable, Hashable {
    
    static let KSaved_BPM = "KSaved_BPM"
    static let KSaved_Meter = "KSaved_Meter"
    static let KSaved_Devide = "KSaved_Devide"
    
    var meter: Int = 4 {
        didSet {
            let ud = UserDefaults.standard
            ud.set(meter, forKey: TempoItem.KSaved_Meter)
            ud.synchronize()
        }
    }
    
    var devide: Int = 4 {
        didSet {
            let ud = UserDefaults.standard
            ud.set(devide, forKey: TempoItem.KSaved_Devide)
            ud.synchronize()
        }
    }

    var bpm: Int = 60 {
        didSet {
            let ud = UserDefaults.standard
            ud.set(bpm, forKey: TempoItem.KSaved_BPM)
            ud.synchronize()
        }
    }
    
    init(meter: Int = 4, devide: Int = 4, bpm: Int = 60) {
        self.meter = meter
        self.devide = devide
        self.bpm = bpm
    }
    
    static var savedMeter: Int {
        let savedMeter = UserDefaults.standard.integer(forKey: KSaved_Meter)
        return savedMeter == 0 ? 4 : savedMeter
    }
    
    static var savedDevide: Int {
        let savedDevide = UserDefaults.standard.integer(forKey: KSaved_Devide)
        return savedDevide == 0 ? 4 : savedDevide
    }
    
    static var savedBPM: Int {
        let savedBPM = UserDefaults.standard.integer(forKey: KSaved_BPM)
        return savedBPM == 0 ? 60 : savedBPM
    }
}
