//
//  MetronomeSettingsScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

struct TempoSettingsScreen: View {
    @State var isCountDownEnable: Bool = TempoSettingsListItem.countDownEnable()
    @State var sortByBPM: Bool = TempoSettingsListItem.sortByBPM()
    private let listData: [TempoSettingsListItem] = [
        .sortByBMP,
        .countDownEnable
    ]

    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(listData, id: \.self) { item in
                        HStack {
                            Image(systemName: item.icon())
                            Text(item.title())
                            Spacer()
                            switchView(item: item)
                                .toggleStyle(SwitchToggleStyle())
                                .tint(Theme.blackColor)
                        }
                        .onChange(of: isCountDownEnable) { newValue in
                            TempoSettingsListItem.saveCountDownEnable(newValue: newValue)
                        }
                        .onChange(of: sortByBPM) { newValue in
                            TempoSettingsListItem.saveSortByBPM(newValue: newValue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Tempo Settings")
    }
    
    @ViewBuilder private func switchView(item: TempoSettingsListItem) -> some View {
        if item == .sortByBMP {
            Toggle("", isOn: $sortByBPM)
        } else {
            Toggle("", isOn: $isCountDownEnable)
        }
    }
}

struct MetronomeSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TempoSettingsScreen()
    }
}
