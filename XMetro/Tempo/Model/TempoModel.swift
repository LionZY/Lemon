//
//  TempoItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/13.
//

import Foundation
import SwiftUI
import GRDB

let meterSet = ["1/4", "2/4", "3/4", "4/4", "5/4", "7/4", "5/8", "6/8", "7/8", "9/8", "12/8"]
let bpmSet = Array(20...280).compactMap { "\($0)" }
let subdivisionSet = ["♩", "♪", "♫", "♬", "♭", "♮", "♯", "𝄡"]
let soundSet = ["Default", "Drum"]

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
    var meter: Int = 4
    var devide: Int = 4
    var bpm: Int = 60
    var subDivision: String = ""
    var soundEffect: String = "Default"
    var soundEffectStong: String {
        soundEffect.appending("_strong")
    }

    init() {}
    
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
    
    static func AllItems(sortByBPM: Bool? = nil) -> [TempoModel]? {
        try? dbQueue?.read { db in
            try TempoModel.fetchAll(db).sorted(by: { t1, t2 in
                if sortByBPM == true { return t1.bpm < t2.bpm }
                else { return t1.uid > t2.uid }
            })
        }
    }
    
    static func one(uid: String) -> TempoModel? {
        return try? dbQueue?.read { db in
            try TempoModel.fetchOne(db, sql: "SELECT * from TempoModel WHERE uid=?", arguments: [uid])
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
