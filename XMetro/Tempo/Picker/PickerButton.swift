//
//  PickerButton.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/13.
//

import SwiftUI

struct PickerButton: View {
    @State var selectedValue: String
    var datas: [String] = []
    var didSubmit: ((String) -> Void)?
    var body: some View {
        VStack {
            Picker("", selection: $selectedValue) {
                ForEach(datas, id: \.self) {
                    Text($0)
                }
            }
            .onChange(of: selectedValue) { newValue in
                didSubmit?(newValue)
            }
        }
    }
}

struct PickerButton_Previews: PreviewProvider {
    static var previews: some View {
        PickerButton(selectedValue: "")
    }
}
