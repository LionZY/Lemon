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
    let defaultIndex: Int
    let action: ((Int) -> Void)?
    
    @State private var selected: Int = 0
    var body: some View {
        Picker(title, selection: $selected) {
            ForEach(datas, id: \.self) {
                Text("\($0.formatted(.number.grouping(.never)))")
                    .font(.title)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .navigationTitle(title)
        .navigationBarItems(
            trailing: Button("Done") {
                action?(selected)
                dismiss()
            }
        ).onAppear {
            selected = defaultIndex
        }
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(title: "", datas: 0..<4, defaultIndex: 2, action: nil)
    }
}

