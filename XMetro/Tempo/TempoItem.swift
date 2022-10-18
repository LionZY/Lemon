//
//  TempoItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/13.
//

import Foundation
import SwiftUI
import GRDB

enum TempoItemSource: Int {
case temp
case db
}

struct TempoItem: Identifiable, Equatable, Hashable, Codable, FetchableRecord, PersistableRecord {
    static func == (lhs: TempoItem, rhs: TempoItem) -> Bool {
        return lhs.id == rhs.id
        && lhs.meter == rhs.meter
        && lhs.devide == rhs.devide
        && lhs.bpm == rhs.bpm
        && lhs.subDivision == rhs.subDivision
        && lhs.soundEffect == rhs.soundEffect
    }
    
    var id = "\(Date.now.timeIntervalSince1970)"
    
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

    init(meter: Int, devide: Int, bpm: Int, subDivision: String, soundEffect: String) {
        self.meter = meter
        self.devide = devide
        self.bpm = bpm
        self.subDivision = subDivision
        self.soundEffect = soundEffect
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

extension TempoItem {
    static func createTable() {
        var exists = true
        let group = GCDGroup.create()
        GCDGroup.enter(group)
        try? dbQueue?.read({ db in
            exists = try db.tableExists("TempoItem")
            GCDGroup.leave(group)
        })
        
        if !exists {
            try? dbQueue?.write { db in
                try db.create(table: "TempoItem") { t in
                    t.column("id")
                    t.column("meter", .integer).notNull()
                    t.column("devide", .integer).notNull()
                    t.column("bpm", .integer).notNull()
                    t.column("subDivision", .text)
                    t.column("soundEffect", .text)
                }
            }
        }
        
        GCDGroup.notify(group)
    }
    
    static func all() -> [TempoItem]? {
        try? dbQueue?.read { db in
            try TempoItem.fetchAll(db)
        }
    }
    
    func replace() {
        try? dbQueue?.write { db in
            if (try Row.fetchOne(db, sql: "SELECT id FROM TempoItem WHERE id = ?", arguments: [self.id])) != nil {
                try self.delete(db)
            }
            try self.insert(db)
        }
    }
    
    func delete() {
        try? dbQueue?.write { db in
            try db.execute(sql: "DELETE FROM TempoItem WHERE id = ?", arguments: [self.id])
        }
    }
}
