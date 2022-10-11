//
//  TunerSettingsItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

enum TunerSettingsListItem: Hashable {
    case auto_open
    
    func icon() -> String {
        switch self {
        case .auto_open: return "tuningfork"
        }
    }
    
    func title() -> String {
        switch self {
        case .auto_open: return "Auto open tuner"
        }
    }
        
    func itemView() -> some View {
        HStack{
            Image(systemName: icon())
            Text(title())
        }
    }
}

