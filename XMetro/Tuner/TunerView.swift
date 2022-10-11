//
//  SecondView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct TunerView: View {
    let tunerData: TunerData
    @State private var selected: IndexPath?
    @State private var auto = true
    @State var modifierPreference: ModifierPreference
    @State var selectedTransposition: Int
    @State var selectedValue: String = "Guitar"
    
    var match: ScaleNote.Match {
         tunerData.closestNote.inTransposition(ScaleNote.allCases[selectedTransposition])
    }
    
    var note: String {
        String(match.note.names.first?.prefix(1) ?? "")
    }
    
    var octave: String? {
        String(match.octave)
    }

    var isPerceptible: Bool {
        match.distance.isPerceptible
    }
    
    var notes: [[String]] {
        selectedValue == "Guitar" ? [["D", "A", "E"], ["G", "B", "E"]] : [["C", "G"], ["E", "A"]]
    }
    
    var octaves: [[String]] {
        selectedValue == "Guitar" ? [["3", "2", "2"], ["3", "3", "4"]] : [["4", "4"], ["4", "4"]]
    }
    
    var segments = ["Guitar", "Ukulele"]

    var body: some View {
        VStack {
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
                ForEach(notes.indices, id: \.self) { m in
                    let subItems = notes[m]
                    VStack {
                        ForEach(Array(subItems.enumerated()), id: \.offset) { n, md in
                            let title = md + octaves[m][n]
                            let indexPath = IndexPath(item: n, section: m)
                            Button(title) {
                                auto = false
                                selected = indexPath
                            }
                            .frame(maxWidth: 60, maxHeight: 60)
                            .background(checkPerceptible(first: md, last: octaves[m][n], indexPath: indexPath))
                            .foregroundColor(Theme.whiteColor)
                            .cornerRadius(30.0)
                        }
                    }.rotationEffect(.degrees((m + 1) % 2 == 0 ? 6.0 : -6.0))
                    Spacer()
                }
            }
            Spacer()
            Toggle("Auto", isOn: $auto)
                .toggleStyle(SwitchToggleStyle(tint: Theme.lightColor))
                .frame(maxWidth: 98.0)
                .onChange(of: auto) { isAuto in
                    if isAuto { selected = nil }
                }
            Spacer()
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("Tuner")
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Picker("", selection: $selectedValue) {
                        ForEach(segments, id: \.self) { t in
                            Text(t).foregroundColor(selectedValue == t ? Theme.lightColor : Color(UIColor(white: 0.0, alpha: 0.3)))
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedValue) { _ in
                        selected = nil
                    }
                }.frame(width: 160.0)
            }
        }
        /*
        .navigationBarItems(
            leading: TranspositionMenu(selectedTransposition: $selectedTransposition)
        )
        */
        .tint(Theme.mainColor)
        .animation(.easeInOut, value: selectedValue)
    }
    
    func checkPerceptible(first: String, last: String, indexPath: IndexPath) -> Color {
        let isSelected = indexPath.section == selected?.section && indexPath.item == selected?.item
        if auto && note == first && last == octave {
            return isPerceptible ? Theme.mainColor : Theme.specialLightColor
        } else if isSelected {
            if isPerceptible {
                return Theme.lightColor
            }
            if note == first && last == octave {
                return Theme.specialLightColor
            }
            return Theme.lightColor
        } else {
            return Theme.mainColor
        }
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
