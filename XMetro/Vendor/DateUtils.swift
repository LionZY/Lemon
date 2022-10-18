//
//  DateUtils.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/17.
//

import Foundation

func StringFromTimeStamp(timeStamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timeStamp)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
}

func DateFromTimeStamp(timeStamp: String) -> Date? {
    guard let interval = TimeInterval.init(timeStamp) else { return nil }
    return Date(timeIntervalSince1970: interval)
}

func DateFromTimeString(time: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.date(from: time)
}

func CurrentTimeStamp() -> String {
    let nowDate = Date.now
    let interval = Int(nowDate.timeIntervalSince1970)
    return "\(interval)"
}
