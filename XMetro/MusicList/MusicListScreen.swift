//
//  MusicListScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/10.
//

import SwiftUI

struct MusicListScreen: View {
    private var listData: [MusicListItem] = [
        MusicListItem(icon: "music.quarternote.3", title: "Chord Library"),
        MusicListItem(icon: "music.note.house.fill", title: "Song Library"),
        MusicListItem(icon: "list.bullet", title: "Setlist Library"),
    ]
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(listData, id: \.self) { item in
                        NavigationLink(destination: SettingsScreen()) {
                            HStack{
                                Image(systemName: item.icon)
                                Text(item.title)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Library")
    }
}

struct MusicListScreen_Previews: PreviewProvider {
    static var previews: some View {
        MusicListScreen()
    }
}
