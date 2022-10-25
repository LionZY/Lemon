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
                        }
                        .onChange(of: isCountDownEnable) { newValue in
                            item.save(newValue: newValue)
                        }
                        .onChange(of: sortByBPM) { newValue in
                            item.save(newValue: newValue)
                        }
                    }
                }
            }
        }
        .onAppear {
            isCountDownEnable = TempoSettingsListItem.countDownEnable()
            sortByBPM = TempoSettingsListItem.sortByBPM()
        }
        .navigationTitle("Tempo Settings")
    }
    
    @ViewBuilder private func switchView(item: TempoSettingsListItem) -> some View {
        switch item {
        case .sortByBMP:
            Toggle("", isOn: $sortByBPM)
        case .countDownEnable:
            Toggle("", isOn: $isCountDownEnable)
        }
    }
}

struct MetronomeSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TempoSettingsScreen()
    }
}
