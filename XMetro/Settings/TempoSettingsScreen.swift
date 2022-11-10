//
//  MetronomeSettingsScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

struct TempoSettingsScreen: View {
    @State var isCountDownEnable: Bool
    @State var countDownTime: String
    @State var sortByBPM: Bool
    private let listData: [String: [TempoSettingsListItem]] = [
        "List": [.sortByBMP],
        "Countdown": [.countDownEnable, .countDownTime]
    ]

    var body: some View {
        VStack {
            List {
                let titles = Array(listData.keys).sorted()
                ForEach(titles, id: \.self) { key in
                    Section(key) {
                        let items = Array(listData[key] ?? [])
                        ForEach(items, id: \.self) { item in
                            HStack {
                                Image(systemName: item.icon())
                                Text(item.title())
                                Spacer()
                                switchView(item: item)
                            }
                        }
                        .onChange(of: isCountDownEnable) { newValue in
                            TempoSettingsListItem.saveCountDownEnable(newValue: newValue)
                        }
                        .onChange(of: sortByBPM) { newValue in
                            TempoSettingsListItem.saveSortByBPM(newValue: newValue)
                        }
                        .onChange(of: countDownTime) { newValue in
                            let value = Int(newValue) ?? TempoSettingsListItem.countDownTime()
                            TempoSettingsListItem.saveCountDownTime(newValue: value)
                        }
                    }
                }
            }
        }
        .navigationTitle("Tempo Settings")
    }
    
    init(
        isCountDownEnable: Bool = TempoSettingsListItem.countDownEnable(),
        countDownTime: Int = TempoSettingsListItem.countDownTime(),
        sortByBPM: Bool = TempoSettingsListItem.sortByBPM()
    ) {
        self.isCountDownEnable = isCountDownEnable
        self.countDownTime = String(countDownTime)
        self.sortByBPM = sortByBPM
    }
    
    @ViewBuilder private func switchView(item: TempoSettingsListItem) -> some View {
        switch item {
        case .sortByBMP:
            Toggle("", isOn: $sortByBPM).toggleStyle(SwitchToggleStyle()).tint(Theme.blackColor)
        case .countDownEnable:
            Toggle("", isOn: $isCountDownEnable).toggleStyle(SwitchToggleStyle()).tint(Theme.blackColor)
        case .countDownTime:
            Picker("", selection: $countDownTime) {
                ForEach(countDownSet, id: \.self) { timeStr in
                    Text(timeStr)
                }
            }
            .pickerStyle(.menu)
            .buttonStyle(.borderless)
            .controlSize(.small)
            .font(.system(size: 14.0))
            .tint(Theme.blackColor)
        }
    }
}

struct MetronomeSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TempoSettingsScreen()
    }
}
