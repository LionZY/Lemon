//
//  PickerView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/9.
//

import SwiftUI
import ComposableArchitecture

enum PickerContentType {
case text
case image
}

struct PickerView: View {
    @State var selectedValue: String
    var didValueChanged: ((String, Bool) -> Void)?
    var datas: [String] = []
    init(datas: [String] = [], selectedValue: String, didValueChanged: ((String, Bool) -> Void)? = nil) {
        self.datas = datas
        self.selectedValue = selectedValue
        self.didValueChanged = didValueChanged
    }

    var body: some View {
        VStack {
            HStack {
                Picker("", selection: $selectedValue) {
                    ForEach(datas, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.wheel)
                .onChange(of: selectedValue) { newValue in
                    didValueChanged?(newValue, false)
                }
            }
        }
    }
}
