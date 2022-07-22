//
//  SecondView.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct TunerView: View {
    let tunerData: TunerData
    @State private var auto = true
    @State var modifierPreference: ModifierPreference
    @State var selectedTransposition: Int
    @State var selectedValue: String = "Guitar"
    
    var match: ScaleNote.Match {
         tunerData.closestNote.inTransposition(ScaleNote.allCases[selectedTransposition])
    }
    
    var segments = ["Guitar", "Ukulele"]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Spacer()
                Picker("", selection: $selectedValue) {
                    ForEach(segments, id: \.self) { t in
                        Text(t).foregroundColor(selectedValue == t ? .red : Color(UIColor(white: 0.0, alpha: 0.3)))
                    }
                }
                .pickerStyle(.segmented)
                Spacer()
                Spacer()
            }
            Spacer()
            VStack() {
                MatchedNoteView(
                    match: match,
                    modifierPreference: modifierPreference
                )
                MatchedNoteFrequency(frequency: tunerData.closestNote.frequency)
                NoteTicks(tunerData: tunerData, showFrequencyText: true)
            }
            Spacer()
            HStack {
                Spacer()
                let datas = selectedValue == "Guitar" ? [["D", "A", "E"], ["G", "B", "E"]] : [["C", "G"], ["E", "A"]]
                ForEach(datas.indices, id: \.self) { index in
                    let subItems = datas[index]
                    VStack {
                        ForEach(subItems, id: \.self) { item in
                            Button(item) { }
                            .frame(maxWidth: 60, maxHeight: 60)
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(30.0)
                        }

                    }.rotationEffect(.degrees((index + 1) % 2 == 0 ? 6.0 : -6.0))
                    Spacer()
                }
            }
            Spacer()
            Toggle("Auto", isOn: $auto).toggleStyle(SwitchToggleStyle(tint: .red)).frame(maxWidth: 98.0)
            Spacer()
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("Tuner")
        .navigationBarItems(
            leading: TranspositionMenu(selectedTransposition: $selectedTransposition)
        )
        .tint(.black)
        .animation(.easeInOut, value: selectedValue)
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        TunerView(
            tunerData: TunerData(),
            modifierPreference: .preferSharps,
            selectedTransposition: 0
        )
    }
}
