//
//  TunerSettingsScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

struct TunerSettingsScreen: View {
    @State var isAutoTunerEnable: Bool = TunerSettingsListItem.autoTuner()
    private let listData: [TunerSettingsListItem] = [
        .autoTuning,
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
                            Toggle("", isOn: $isAutoTunerEnable)
                        }
                        .onChange(of: isAutoTunerEnable) { newValue in
                            item.save(newValue: newValue)
                        }
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
