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
        && lhs.source == rhs.source
        && lhs.meter == rhs.meter
        && lhs.devide == rhs.devide
        && lhs.bpm == rhs.bpm
        && lhs.subDivision == rhs.subDivision
    }
    
    static let KSaved_BPM = "KSaved_BPM"
    static let KSaved_Meter = "KSaved_Meter"
    static let KSaved_Devide = "KSaved_Devide"
    static let KSaved_Subdivision = "KSaved_Subdivision"
    
    let id = "\(Date.now.timeIntervalSince1970)"
    let source = ""
    
    var meter: Int {
        didSet {
            let ud = UserDefaults.standard
            ud.set(meter, forKey: TempoItem.KSaved_Meter)
            ud.synchronize()
        }
    }
    
    var devide: Int {
        didSet {
            let ud = UserDefaults.standard
            ud.set(devide, forKey: TempoItem.KSaved_Devide)
            ud.synchronize()
        }
    }

    var bpm: Int {
        didSet {
            let ud = UserDefaults.standard
            ud.set(bpm, forKey: TempoItem.KSaved_BPM)
            ud.synchronize()
        }
    }
    
    var subDivision: String {
        didSet {
            let ud = UserDefaults.standard
            ud.set(subDivision, forKey: TempoItem.KSaved_Subdivision)
            ud.synchronize()
        }
    }
    
    init() {
        self.meter = TempoItem.savedMeter
        self.devide = TempoItem.savedDevide
        self.bpm = TempoItem.savedBPM
        self.subDivision = TempoItem.savedSubdivision
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
    
    static var savedSubdivision: String {
        guard let savedSubdivision = UserDefaults.standard.string(forKey: KSaved_Subdivision) else { return "♩" }
        return savedSubdivision
    }
}
