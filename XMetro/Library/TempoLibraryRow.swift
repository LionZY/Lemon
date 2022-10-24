//
//  TempoLibraryRow.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/18.
//

import SwiftUI

struct TempoLibraryRow: View {
    @Binding var manager: TempoRunManager
    var item: TempoModel
    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 8.0) {
                TempoDotsView(manager: $manager, type: .small, tempo: item)
                Spacer().frame(height: 4.0)
                Text("Time signature: \(item.meter)/\(item.devide)")
                Text("BPM: \(item.bpm)")
                Text(StringFromTimeStamp(timeStamp: Double(item.uid) ?? 0))
                    .font(Font.system(size: 12))
            }
            Spacer()
            VStack {
                TempoRunButton(manager: $manager, tempo: item)
                    .onTapGesture {
                        if manager.tempoItem.uid != item.uid { manager.stop() }
                        manager.tempoItem = item
                        manager.nextAction()
                    }
                    .frame(width: 64.0, height: 64.0)
                    .background(Theme.mainColor)
                    .foregroundColor(Theme.whiteColor)
                    .cornerRadius(8.0)
            }
        }
        .foregroundColor(Theme.grayColor)
        .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 4.0, trailing: 8.0))
    }
}
