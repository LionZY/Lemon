//
//  BoredButtonAction.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/8.
//

import Foundation

enum BoredButtonAction: Equatable {
    case run
    case stop
    case updateBpm(Int)
    case updateCount(Int)
}
