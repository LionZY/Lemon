//
//  PickerView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/9.
//

import SwiftUI
import ComposableArchitecture

struct PickerView: View {
    
    @Environment(\.dismiss) var dismiss
    var title: String
    var subject1Range: Range<Int>
    var subject1: [Int]
    let subject1Colum = 4
    var subject1Row: Int {
        subject1.count % subject1Colum == 0 ? subject1.count / subject1Colum : subject1.count / subject1Colum + 1
    }
    let subject1DefaultValue: Int
    
    var subject2: [Int] = []
    let subject2DefaultValue: Int?

    let action: ((Int, Int) -> Void)?
    private var showSubject2: Bool { subject2.count > 0 }
    private let subject1Edge = EdgeInsets(top: 0, leading: UIScreen.main.bounds.width / 4.0 + 20, bottom: 0, trailing: 0)
    private let subject2Edge = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: UIScreen.main.bounds.width / 4.0 + 20)
    
    
    @State private var selectedSubject1Value: Int = 0
    @State private var selectedSubject2Value: Int = 4

    var body: some View {
        VStack {
            Spacer()
            ForEach(0..<subject1Row, id: \.self) { rw in
                HStack {
                    ForEach(0..<subject1Colum, id: \.self) { col in
                        let index = rw * subject1Colum + col
                        if index < subject1.count {
                            let title = showSubject2 ? "\(subject1[index])/\(selectedSubject2Value)" : "\(subject1[index])"
                            Button(title) {
                                selectedSubject1Value = subject1[index]
                                action?(selectedSubject1Value, selectedSubject2Value)
                                dismiss()
                            }
                            .frame(maxWidth: 60, maxHeight: 60)
                            .background(selectedSubject1Value == subject1[index] ? Theme.lightColor : Theme.mainColor)
                            .foregroundColor(Theme.whiteColor)
                            .cornerRadius(30.0)
                        }
                    }
                }
            }
            Spacer()
            pickerView()
        }
        .navigationTitle(title)
        .navigationBarItems(
            trailing: Button("Done") {
                action?(selectedSubject1Value, selectedSubject2Value)
                dismiss()
            }
        ).onAppear {
            selectedSubject1Value = subject1DefaultValue
            guard let subject2DefaultValue = subject2DefaultValue else  {
                selectedSubject2Value = 4
                return
            }
            selectedSubject2Value = subject2DefaultValue
        }
    }
    
    @ViewBuilder func pickerView() -> some View {
        if showSubject2 {
            HStack {
                Picker("", selection: $selectedSubject1Value) {
                    ForEach(subject1Range, id: \.self) {
                        Text("\($0.formatted(.number.grouping(.never)))").padding(subject1Edge)
                    }
                }
                .pickerStyle(.wheel)
                Text("/")
                Picker("", selection: $selectedSubject2Value) {
                    ForEach(subject2, id: \.self) {
                        Text("\($0.formatted(.number.grouping(.never)))").padding(subject2Edge)
                    }
                }
                .fixedSize()
                .pickerStyle(.wheel)
            }
        } else {
            HStack {
                Picker("", selection: $selectedSubject1Value) {
                    ForEach(subject1Range, id: \.self) {
                        Text("\($0.formatted(.number.grouping(.never)))")
                    }
                }
                .fixedSize()
                .pickerStyle(.wheel)
            }
        }
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(title: "", subject1Range: 0..<4, subject1: [], subject1DefaultValue: 2, subject2DefaultValue: 4, action: nil)
    }
}

