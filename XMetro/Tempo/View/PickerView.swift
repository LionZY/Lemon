//
//  PickerView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/9.
//

import SwiftUI
import ComposableArchitecture

extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)
    }
}

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
        HStack {
            Picker("", selection: $selectedValue) {
                ForEach(datas, id: \.self) {
                    Text($0).foregroundColor(Theme.whiteColor)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: .infinity, maxHeight: Theme.pickerHeight)
            .clipped()
            .onChange(of: selectedValue) { newValue in
                didValueChanged?(newValue, false)
            }
        }
    }
}

struct TwoPickerView: View {
    
    @State private var leftSelectedValue: String
    @State private var rightSelectedValue: String
    
    private var innerSelectedValue: String {
        "\(leftSelectedValue)/\(rightSelectedValue)"
    }

    var didValueChanged: ((String, Bool) -> Void)?
    var leftDatas: [String] = []
    var rightDatas: [String] = []
    var splitText: String = "/"
    
    init(
        leftDatas: [String] = [],
        rightDatas: [String] = [],
        splitText: String = "/",
        selectedValue: String,
        didValueChanged: ((String, Bool) -> Void)? = nil
    ) {
        self.leftDatas = leftDatas
        self.rightDatas = rightDatas
        self.splitText = splitText
        self.leftSelectedValue = selectedValue.components(separatedBy: splitText).first ?? "--"
        self.rightSelectedValue = selectedValue.components(separatedBy: splitText).last ?? "--"
        self.didValueChanged = didValueChanged
    }
    
    var body: some View {
        HStack {
            VStack {
                Picker("", selection: $leftSelectedValue) {
                    ForEach(leftDatas, id: \.self) {
                        Text($0).foregroundColor(Theme.whiteColor)
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                .frame(width: 130, height: Theme.pickerHeight)
                .clipped()
            }
            Text(splitText).foregroundColor(Theme.whiteColor)
            VStack {
                Picker("", selection: $rightSelectedValue) {
                    ForEach(rightDatas, id: \.self) {
                        Text($0).foregroundColor(Theme.whiteColor)
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                .frame(width: 130, height: Theme.pickerHeight)
                .clipped()
            }
        }
        .onChange(of: leftSelectedValue) { newValue in
            didValueChanged?(innerSelectedValue, false)
        }
        .onChange(of: rightSelectedValue) { newValue in
            didValueChanged?(innerSelectedValue, false)
        }
    }
}
