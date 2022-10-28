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
    @State private var autoTuning = TunerSettingsListItem.autoTuner()
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
            VStack {
                MatchedNoteView(
                    match: match,
                    modifierPreference: modifierPreference
                )
                Spacer().frame(height: 30.0)
                MatchedNoteFrequency(frequency: tunerData.closestNote.frequency)
                NoteTicks(tunerData: tunerData)
            }
            Spacer()
            HStack {
                Spacer()
                ForEach(notes.indices, id: \.self) { m in
                    let subItems = notes[m]
                    VStack {
                        ForEach(Array(subItems.enumerated()), id: \.offset) { n, md in
                            let noteTitle = md
                            let octiveTitle = octaves[m][n]
                            let indexPath = IndexPath(item: n, section: m)
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Text(noteTitle).font(.system(size: 24)).frame(height: 24)
                                Text(octiveTitle).font(.system(size: 14)).frame(height: 14)
                            }
                            .frame(maxWidth: 60, maxHeight: 60)
                            .background(checkPerceptible(first: md, last: octaves[m][n], indexPath: indexPath))
                            .foregroundColor(Theme.whiteColor)
                            .cornerRadius(30.0)
                            .onTapGesture {
                                autoTuning = false
                                selected = indexPath
                            }
                        }
                    }
                    .rotationEffect(.degrees((m + 1) % 2 == 0 ? 6.5 : -6.5))
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("Tuner")
        .navigationBarItems(
            leading: HStack {
                Picker("", selection: $selectedValue) {
                    ForEach(segments, id: \.self) { t in
                        Text(t).foregroundColor(selectedValue == t ? Theme.redColor : Color(UIColor(white: 0.0, alpha: 0.3)))
                    }
                }
                .frame(width: 140.0)
                .pickerStyle(.segmented)
                .onChange(of: selectedValue) { _ in
                    selected = nil
                }
            },
            trailing: Toggle("Auto", isOn: $autoTuning)
                .toggleStyle(SwitchToggleStyle())
                .frame(maxWidth: 98.0)
                .onChange(of: autoTuning) { isAuto in
                    if isAuto { selected = nil }
                }
        )
        .tint(Theme.blackColor)
        .animation(.easeInOut, value: selectedValue)
    }
    
    func checkPerceptible(first: String, last: String, indexPath: IndexPath) -> Color {
        let isSelected = indexPath.section == selected?.section && indexPath.item == selected?.item
        if autoTuning && note == first && last == octave {
            return isPerceptible ? Theme.blackColor : Theme.greenColor
        } else if isSelected {
            if isPerceptible {
                return Theme.redColor
            }
            if note == first && last == octave {
                return Theme.greenColor
            }
            return Theme.redColor
        } else {
            return Theme.blackColor
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
