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
            VStack(alignment: .leading, spacing: 10.0) {
                HStack {
                    Text("Time signature:")
                    Text("\(item.meter)/\(item.devide)")
                }
                HStack {
                    Text("BPM:")
                    Text("\(item.bpm)")
                }
                Spacer()
                Text(StringFromTimeStamp(timeStamp: Double(item.uid) ?? 0))
                .font(Font.system(size: 12))
            }
            Spacer()
            TempoRunButton(manager: $manager, tempo: item)
                .onTapGesture {
                    manager.tempoItem = item
                    manager.nextAction()
                }
                .frame(width: 64.0, height: 64.0)
                .background(Theme.mainColor)
                .foregroundColor(Theme.whiteColor)
                .cornerRadius(8.0)
        }
        .foregroundColor(Theme.grayColor)
        .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
    }
}
