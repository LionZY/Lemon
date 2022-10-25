//
//  TempoLibraryRow.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/18.
//

import SwiftUI

struct TemposListRow: View {
    @Binding var manager: TempoRunManager
    @State private var selected: Bool = false
    var item: TempoModel
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading, spacing: 8.0) {
                    TempoDotsView(manager: $manager, tempo: item, style: .row)
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
                            if !selected { manager.stop() }
                            manager.tempoItem = item
                            manager.nextAction()
                        }
                        .frame(width: 64.0, height: 64.0)
                        .background(Theme.mainColor)
                        .foregroundColor(Theme.whiteColor)
                        .cornerRadius(8.0)
                    if selected {
                        Spacer().frame(height: 8.0)
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Theme.lightColor)
                    }
                }
            }
        }
        .foregroundColor(Theme.grayColor)
        .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 4.0, trailing: 8.0))
        .onAppear {
            selected = manager.tempoItem.uid == item.uid
            manager.register(key: "\(TemposListRow.self)_\(item.uid)") {
                selected = manager.tempoItem.uid == item.uid
            }
        }
    }
}
