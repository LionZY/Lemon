//
//  LibraryListItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/10.
//

import SwiftUI

enum LibraryListItem: Hashable {
    case chord
    case tempo
    case setlist
    
    func icon() -> String {
        switch self {
        case .chord: return "music.quarternote.3"
        case .tempo: return "music.note.house.fill"
        case .setlist: return "list.bullet.rectangle.fill"
        }
    }

    func title() -> String {
        switch self {
        case .chord: return "Chord Library"
        case .tempo: return "Tempo Library"
        case .setlist: return "Setlist Library"
        }
    }
    
    @ViewBuilder func destination() -> some View {
        switch self {
        case .chord: ChordScreen()
        case .tempo: TempoScreen()
        case .setlist: SetlistScreen()
        }
    }
    
    func itemView() -> some View {
        NavigationLink(destination: destination()) {
            HStack{
                Image(systemName: icon())
                Text(title())
            }
        }
    }
}
