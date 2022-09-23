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
    @State var selectedValue: String = "Guitar" {
        didSet {
            selected = nil
        }
    }
    
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
                            Button(title) {
                                auto = false
                                selected = IndexPath(item: n, section: m)
                            }
                            .frame(maxWidth: 60, maxHeight: 60)
                            .background(checkPerceptible(first: md, last: octaves[m][n]))
                            .foregroundColor(.white)
                            .cornerRadius(30.0)
                        }
                    }.rotationEffect(.degrees((m + 1) % 2 == 0 ? 6.0 : -6.0))
                    Spacer()
                }
            }
            Spacer()
            Toggle("Auto", isOn: $auto).toggleStyle(SwitchToggleStyle(tint: .red)).frame(maxWidth: 98.0)
            Spacer()
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("Tuner")
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Picker("", selection: $selectedValue) {
                        ForEach(segments, id: \.self) { t in
                            Text(t).foregroundColor(selectedValue == t ? .red : Color(UIColor(white: 0.0, alpha: 0.3)))
                        }
                    }
                    .pickerStyle(.segmented)
                }.frame(width: 160.0)
            }
        }
        /*
        .navigationBarItems(
            leading: TranspositionMenu(selectedTransposition: $selectedTransposition)
        )
        */
        .tint(.black)
        .animation(.easeInOut, value: selectedValue)
    }
    
    func checkPerceptible(first: String, last: String) -> Color {
        if auto {
            if note == first && last == octave {
                return isPerceptible ? .black : .green
            } else {
                return .black
            }
        } else if let section = selected?.section, let item = selected?.item {
            if first == notes[section][item] && last == octaves[section][item] {
                return isPerceptible ? .red : .green
            } else {
                return .black
            }
        }
        return .black
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
