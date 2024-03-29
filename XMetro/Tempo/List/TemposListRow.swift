//
//  TempoLibraryRow.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/18.
//

import SwiftUI

struct TemposListRow: View {
    @ObservedObject var manager: TempoRunManager
    @State private var selected: Bool = false
    private var timeStampStr: String {
        StringFromTimeStamp(timeStamp: Double(item.uid) ?? 0)
    }
    @State var item: TempoModel
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                if selected {
                    TempoRunButton(manager: manager, tempoId: item.uid)
                        .onTapGesture {
                            if !selected { manager.stop() }
                            manager.state.tempoItem = item
                            manager.nextAction()
                        }
                        .frame(width: Theme.largeButtonHeight, height: Theme.largeButtonHeight)
                        .foregroundColor(Theme.whiteColor)
                } else {
                    VStack {
                        Text("BPM")
                            .font(.system(size: 12))
                            .italic()
                        Text("\(item.bpm)")
                            .font(.custom("Charter-BoldItalic", size: 22))
                    }
                    .frame(width: Theme.largeButtonHeight, height: Theme.largeButtonHeight)
                    .background(Theme.grayColorF5.cornerRadius(8))
                    .foregroundColor(Theme.blackColor)
                }
            }
            Spacer().frame(width: 12.0)
            VStack(alignment: .leading) {
                /*
                Spacer().frame(height: 5.0)
                HStack {
                    Image(systemName: "clock").foregroundColor(Theme.grayColor8).font(.system(size: 14))
                    Spacer().frame(width: 8.0)
                    Text("Duration(minutes):").foregroundColor(Theme.grayColor8).font(.system(size: 14))
                    Spacer()
                    Text("\(item.duration)").foregroundColor(Theme.grayColorB).font(.custom("Charter-BoldItalic", size: 14))
                }
                */
                Spacer()
                HStack(spacing: 0) {
                    Image(systemName: "timer.circle").foregroundColor(Theme.grayColor8).font(.system(size: 14))
                    Spacer().frame(width: 8.0)
                    Text("Time signature:").foregroundColor(Theme.grayColor8).font(.system(size: 14))
                    Spacer()
                    Text("\(item.meter)/\(item.devide)").foregroundColor(Theme.grayColorB).font(.custom("Charter-BoldItalic", size: 14))
                }
                Spacer().frame(height: 5.0)
                HStack(spacing: 0) {
                    Image(systemName: "speaker.circle").foregroundColor(Theme.grayColor8).font(.system(size: 14))
                    Spacer().frame(width: 8.0)
                    Text("Sound effect:").foregroundColor(Theme.grayColor8).font(.system(size: 14))
                    Spacer()
                    Text(item.soundEffect).foregroundColor(Theme.grayColorB).font(.custom("Charter-BoldItalic", size: 14))
                }
                Spacer().frame(height: 5.0)
                HStack {
                    Image(systemName: "smallcircle.filled.circle").foregroundColor(Theme.grayColor8).font(.system(size: 14))
                    Spacer().frame(width: 8.0)
                    TempoDotsView(manager: manager, tempoId: item.uid, style: .row)
                }
                Spacer()
            }
            Spacer()
        }
        .onAppear {
            selected = manager.state.tempoItem.uid == item.uid
            manager.register(key: "\(TemposListRow.self)_\(item.uid)") {
                selected = manager.state.tempoItem.uid == item.uid
            }
        }
    }
}
