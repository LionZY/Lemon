//
//  PickerView.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/9.
//

import SwiftUI
import ComposableArchitecture

struct PickerView: View {
    
    @Environment(\.dismiss) var dismiss
    var title: String
    var datas: Range<Int>
    var presets: [Int]
    let presetColum = 4
    var presetRow: Int {
        presets.count % presetColum == 0 ? presets.count / presetColum : presets.count / presetColum + 1
    }
    let defaultValue: Int
    let action: ((Int) -> Void)?
    
    @State private var selectedValue: Int = 0

    var body: some View {
        VStack {
            Spacer()
            Spacer()
            ForEach(0..<presetRow, id: \.self) { rw in
                HStack {
                    ForEach(0..<presetColum, id: \.self) { col in
                        let index = rw * presetColum + col
                        if index < presets.count {
                            Button("\(presets[index])") {
                                selectedValue = presets[index] 
                                action?(selectedValue)
                                dismiss()
                            }
                            .frame(maxWidth: 60, maxHeight: 60)
                            .background(selectedValue == presets[index] ? .red : .black)
                            .foregroundColor(.white)
                            .cornerRadius(30.0)
                        }
                    }
                }
            }
            Spacer()
            Picker(title, selection: $selectedValue) {
                ForEach(datas, id: \.self) {
                    Text("\($0.formatted(.number.grouping(.never)))")
                        .font(.title)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .navigationTitle(title)
            .navigationBarItems(
                trailing: Button("Done") {
                    action?(selectedValue)
                    dismiss()
                }
            ).onAppear {
                selectedValue = defaultValue
            }
        }
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(title: "", datas: 0..<4, presets: [], defaultValue: 2,  action: nil)
    }
}

