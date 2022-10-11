//
//  TunerSettingsScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

struct TunerSettingsScreen: View {
    private let listData: [TunerSettingsListItem] = [
        .auto_open,
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
        .navigationTitle("Tuner Settings")
    }
}

struct TunerSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TunerSettingsScreen()
    }
}
