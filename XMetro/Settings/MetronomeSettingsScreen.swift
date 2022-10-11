//
//  MetronomeSettingsScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

struct MetronomeSettingsScreen: View {
    private let listData: [MetronomeSettingsListItem] = [
        .default_meter,
        .default_bpm
    ]
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(listData, id: \.self) { item in
                        item.itemView()
                    }
                }
            }
        }
        .navigationTitle("Metronome Settings")
    }
}

struct MetronomeSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeSettingsScreen()
    }
}
