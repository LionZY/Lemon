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
    private var timeStampStr: String {
        StringFromTimeStamp(timeStamp: Double(item.uid) ?? 0)
    }
    var item: TempoModel
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Time signature:").foregroundColor(Theme.darkGrayColor)
                        Text("\(item.meter)/\(item.devide)").foregroundColor(Theme.lightGrayColor)
                    }
                    .font(Font.system(size: 16))
                    Spacer().frame(height: 2.0)
                    HStack {
                        Text("BPM:").foregroundColor(Theme.darkGrayColor)
                        Text("\(item.bpm)").foregroundColor(Theme.lightGrayColor)
                    }
                    .font(Font.system(size: 16))
                    Spacer().frame(height: 2.0)
                    HStack {
                        Text("Sound effect:").foregroundColor(Theme.darkGrayColor)
                        Text(item.soundEffect).foregroundColor(Theme.lightGrayColor)
                    }
                    .font(Font.system(size: 16))
                    Spacer()
                    Text(timeStampStr)
                        .foregroundColor(Theme.lightGrayColor)
                        .font(Font.system(size: 12))
                    Spacer().frame(height: 2.0)
                }
                Spacer()
                TempoDotsView(manager: $manager, tempo: item, style: .row)
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
                .frame(width: 64.0, height: 88.0)
            }
        }
        .foregroundColor(Theme.grayColor)
        .padding(EdgeInsets(top: 8.0, leading: 0.0, bottom: 8.0, trailing: 0.0))
        .onAppear {
            selected = manager.tempoItem.uid == item.uid
            manager.register(key: "\(TemposListRow.self)_\(item.uid)") {
                selected = manager.tempoItem.uid == item.uid
            }
        }
    }
}
