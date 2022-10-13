//
//  TempoViewAction.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/8.
//

import Foundation

enum TempoViewAction: Equatable {
    case run
    case stop
    case updateBpm(Int)
    case updateTimeSignature(Int, Int)
    case updateSubdivision(String)
}
