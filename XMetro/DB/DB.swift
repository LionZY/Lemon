//
//  DB.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/17.
//

import GRDB

let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
let documentPath = documentPaths.first ?? ""
let dbPath = documentPath.appending("/xmetro.sqlite")
let dbQueue = try? DatabaseQueue(path: dbPath)

func CreateTables() {
    TempoModel.createTable()
}

