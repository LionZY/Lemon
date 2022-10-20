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

struct TempoModel: Equatable, Hashable, Codable, FetchableRecord, PersistableRecord {
    static func == (lhs: TempoModel, rhs: TempoModel) -> Bool {
        return lhs.uid == rhs.uid
        && lhs.meter == rhs.meter
        && lhs.devide == rhs.devide
        && lhs.bpm == rhs.bpm
        && lhs.subDivision == rhs.subDivision
        && lhs.soundEffect == rhs.soundEffect
    }
    
    var uid: String = "\(Date.now.timeIntervalSince1970)"
    var meter: Int = TempoModel.meter
    var devide: Int = TempoModel.devide
    var bpm: Int = TempoModel.bpm
    var subDivision: String = TempoModel.subdivision
    var soundEffect: String = TempoModel.soundEffect
    var soundEffectStong: String {
        soundEffect.appending("_strong")
    }

    init() {
        self.uid = "\(Date.now.timeIntervalSince1970)"
        self.meter = TempoModel.meter
        self.devide = TempoModel.devide
        self.bpm = TempoModel.bpm
        self.subDivision = TempoModel.subdivision
        self.soundEffect = TempoModel.soundEffect
    }
    
    init(meter: Int, devide: Int, bpm: Int, subDivision: String, soundEffect: String) {
        self.meter = meter
        self.devide = devide
        self.bpm = bpm
        self.subDivision = subDivision
        self.soundEffect = soundEffect
        self.uid = "\(Date.now.timeIntervalSince1970)"
    }
    
    enum CodingKeys: String, CodingKey {
        case uid, meter, devide, bpm, subDivision, soundEffect
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.meter = try container.decode(Int.self, forKey: .meter)
        self.devide = try container.decode(Int.self, forKey: .devide)
        self.bpm = try container.decode(Int.self, forKey: .bpm)
        self.subDivision = try container.decode(String.self, forKey: .subDivision)
        self.soundEffect = try container.decode(String.self, forKey: .soundEffect)
    }
}

extension TempoModel {
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
        guard let soundEffect = UserDefaults.standard.string(forKey: KSaved_SoundEffect) else { return "Default" }
        return soundEffect
    }
    
    static var soundEffectStrong: String {
        soundEffect.appending("_strong")
    }
    
    static func save(_ value: Any, forKey: String) {
        let ud = UserDefaults.standard
        ud.set(value, forKey: forKey)
        ud.synchronize()
    }
    
    static func saveTimeSignature(_ value: String) {
        let components = value.components(separatedBy: "/")
        let newMeter = Int(components.first ?? "4") ?? 4
        let newDevide = Int(components.last ?? "4") ?? 4
        save(newMeter, forKey: KSaved_Meter)
        save(newDevide, forKey: KSaved_Devide)
    }
    
    static func saveBPM(_ value: Int) {
        save(value, forKey: KSaved_BPM)
    }
    
    static func saveSubdivision(_ value: String) {
        save(value, forKey: KSaved_Subdivision)
    }
    
    static func saveSoundEffect(_ value: String) {
        save(value, forKey: KSaved_SoundEffect)
    }
}

extension TempoModel {
    static func createTable() {
        var existsOldTable = true
        let group = XGCDGroup.create()
        XGCDGroup.enter(group)
        try? dbQueue?.read({ db in
            existsOldTable = try db.tableExists("TempoItem")
            XGCDGroup.leave(group)
        })
        
        if existsOldTable {
            try? dbQueue?.inDatabase({ db in
                try db.beginTransaction()
                try db.execute(sql:
                    """
                    CREATE TEMPORARY TABLE t1_backup(uid,meter,devide,bpm,subDivision,soundEffect);
                    INSERT INTO t1_backup(uid,meter,devide,bpm,subDivision,soundEffect) SELECT DISTINCT id,meter,devide,bpm,subDivision,soundEffect FROM TempoItem;
                    DROP TABLE TempoItem;
                    CREATE TABLE TempoModel(
                        uid TEXT PRIMARY KEY,
                        meter INTEGER NOT NULL,
                        devide INTEGER NOT NULL,
                        bpm INTEGER NOT NULL,
                        subDivision TEXT,
                        soundEffect TEXT
                    );
                    INSERT INTO TempoModel SELECT uid,meter,devide,bpm,subDivision,soundEffect FROM t1_backup;
                    DROP TABLE t1_backup;
                    """
                )
                try db.commit()
            })
        }
        
        var existsNewTable = true
        XGCDGroup.enter(group)
        try? dbQueue?.read({ db in
            existsNewTable = try db.tableExists("TempoModel")
            XGCDGroup.leave(group)
        })
        if !existsNewTable {
            try? dbQueue?.write { db in
                try db.create(table: "TempoModel") { t in
                    t.column("uid", .text).primaryKey()
                    t.column("meter", .integer).notNull()
                    t.column("devide", .integer).notNull()
                    t.column("bpm", .integer).notNull()
                    t.column("subDivision", .text)
                    t.column("soundEffect", .text)
                }
            }
        }
        XGCDGroup.notify(group)
    }
    
    static func AllItems() -> [TempoModel]? {
        return try? dbQueue?.read { db in
            try TempoModel.fetchAll(db).sorted(by: { t1, t2 in
                t1.uid > t2.uid
            })
        }
    }
    
    func replace() {
        try? dbQueue?.write { db in
            try db.execute(
                sql: "REPLACE INTO TempoModel(uid,meter,devide,bpm,subDivision,soundEffect) VALUES(?,?,?,?,?,?)",
                arguments: [uid,meter,devide,bpm,subDivision,soundEffect]
            )
        }
    }
    
    func delete() {
        try? dbQueue?.write { db in
            try db.execute(sql: "DELETE FROM TempoModel WHERE uid=?;", arguments: [uid])
        }
    }
}
