//
//  MetronomeSettingsScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

struct MetronomeSettingsScreen: View {
    @State var isCountDownEnable: Bool = MetronomeSettingsListItem.countDownEnable()
    private let listData: [MetronomeSettingsListItem] = [
        //.autoSaveTimeSignature,
        //.autoSaveBPM
        .countDownEnable
    ]

    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(listData, id: \.self) { item in
                        HStack{
                            Image(systemName: item.icon())
                            Text(item.title())
                            Spacer()
                            Toggle("", isOn: $isCountDownEnable)
                        }
                        .onChange(of: isCountDownEnable) { newValue in
                            item.save(newValue: newValue)
                        }
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
