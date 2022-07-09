//
//  TabItem.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct TabItemState: Equatable, Hashable {
    var icon: String = ""
    var title: String = ""
    var select: Bool = false
    var index: Int = 0
}
