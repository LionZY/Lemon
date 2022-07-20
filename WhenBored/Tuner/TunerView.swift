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
    @State var modifierPreference: ModifierPreference
    @State var selectedTransposition: Int
    private var match: ScaleNote.Match {
         tunerData.closestNote.inTransposition(ScaleNote.allCases[selectedTransposition])
    }
    
    @State private var selectedValue: String = "Guitar"
    var datas = [["D", "A", "E"], ["G", "B", "E"]]
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
            Spacer()
            HStack {
                Spacer()
                ForEach(datas.indices, id: \.self) { index in
                    let subItems = datas[index]
                    VStack {
                        ForEach(subItems, id: \.self) { item in
                            Button(item) {
                                
                            }
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
            Spacer()
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("Tuner")
        .navigationBarItems(trailing: TranspositionMenu(selectedTransposition: $selectedTransposition))
        .tint(.black)
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
