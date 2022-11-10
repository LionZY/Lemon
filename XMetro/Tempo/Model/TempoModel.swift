//
//  TempoItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/13.
//

import Foundation
import SwiftUI
import GRDB

let meterSet = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
let devideSet = ["1", "2", "3", "4", "5", "6", "7", "8"]
let bpmSet = Array(20...280).compactMap { "\($0)" }
let soundSet = ["Default", "Drum"]
let countDownSet = ["3", "4", "5", "6", "7", "8"]
var durationSet: [String] {
    let sets = Array(5...240).compactMap { "\($0)" }
    return ["Inf"] + sets
}

struct TempoModel: Equatable, Hashable, Codable, FetchableRecord, PersistableRecord {
    static func == (lhs: TempoModel, rhs: TempoModel) -> Bool {
        return lhs.uid == rhs.uid
        && lhs.meter == rhs.meter
        && lhs.devide == rhs.devide
        && lhs.bpm == rhs.bpm
        && lhs.subDivision == rhs.subDivision
        && lhs.soundEffect == rhs.soundEffect
        && lhs.duration == rhs.duration
    }
    
    var uid: String = "\(Date.now.timeIntervalSince1970)"
    var meter: Int = 4
    var devide: Int = 4
    var bpm: Int = 60
    var subDivision: String = ""
    var soundEffect: String = "Default"
    var duration: String = "Inf"
    var soundEffectStong: String {
        soundEffect.appending("_strong")
    }

    init() {}
    
    enum CodingKeys: String, CodingKey {
        case uid, meter, devide, bpm, subDivision, soundEffect, duration
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.meter = try container.decode(Int.self, forKey: .meter)
        self.devide = try container.decode(Int.self, forKey: .devide)
        self.bpm = try container.decode(Int.self, forKey: .bpm)
        self.subDivision = try container.decode(String.self, forKey: .subDivision)
        self.soundEffect = try container.decode(String.self, forKey: .soundEffect)
        self.duration = try container.decode(String.self, forKey: .duration)
    }
}

extension TempoModel {
    static func createTable() {
        let group = XGCDGroup.create()
        if tableExists(name: "TempoItem", group: group) {
            dropTempoItemAndTempoModel()
        }
        if tableExists(name: "TempoModel", group: group) {
            if columExists(name: "duration", inTable: "TempoModel", group: group) != true {
                AddDurationColumToTempoModel(group: group)
            }
        } else {
            createTempoModel()
        }
        XGCDGroup.notify(group)
    }
    
    static private func dropTempoItemAndTempoModel() {
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
                    soundEffect TEXT,
                    duration TEXT
                );
                INSERT INTO TempoModel SELECT uid,meter,devide,bpm,subDivision,soundEffect FROM t1_backup;
                DROP TABLE t1_backup;
                """
            )
            try db.commit()
        })
    }
    
    static private func AddDurationColumToTempoModel(group: DispatchGroup) {
        try? dbQueue?.write { db in
            try db.alter(table: "TempoModel", body: { t in
                t.add(column: "duration", .text).notNull().defaults(to: "Inf")
            })
        }
    }
    
    static private func tableExists(name: String, group: DispatchGroup) -> Bool {
        var exists: Bool?
        XGCDGroup.enter(group)
        try? dbQueue?.read { db in
            exists = try db.tableExists(name)
            XGCDGroup.leave(group)
        }
        return exists == true
    }
    
    static private func columExists(name: String, inTable: String, group: DispatchGroup) -> Bool? {
        var colums: [ColumnInfo]?
        XGCDGroup.enter(group)
        try? dbQueue?.read { db in
            colums = try db.columns(in: inTable)
            XGCDGroup.leave(group)
        }
        let exists = colums?.contains(where: { info in
            return info.name == name
        })
        return exists
    }

    static private func createTempoModel() {
        try? dbQueue?.write { db in
            try db.create(table: "TempoModel") { t in
                t.column("uid", .text).primaryKey()
                t.column("meter", .integer).notNull()
                t.column("devide", .integer).notNull()
                t.column("bpm", .integer).notNull()
                t.column("subDivision", .text)
                t.column("soundEffect", .text)
                t.column("duration", .text)
            }
        }
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
                sql: "REPLACE INTO TempoModel(uid,meter,devide,bpm,subDivision,soundEffect,duration) VALUES(?,?,?,?,?,?,?)",
                arguments: [uid,meter,devide,bpm,subDivision,soundEffect,duration]
            )
        }
    }
    
    func delete() {
        try? dbQueue?.write { db in
            try db.execute(sql: "DELETE FROM TempoModel WHERE uid=?;", arguments: [uid])
        }
    }
}
