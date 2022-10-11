//
//  MetronomeSettingsListItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

enum MetronomeSettingsListItem: Hashable {
    case default_meter
    case default_bpm
    
    func icon() -> String {
        switch self {
        case .default_meter: return "dot.squareshape"
        case .default_bpm: return "note"
        }
    }
    
    func title() -> String {
        switch self {
        case .default_meter: return "Auto save time signature"
        case .default_bpm: return "Auto save bpm"
        }
    }
        
    func itemView() -> some View {
        HStack{
            Image(systemName: icon())
            Text(title())
        }
    }
}

