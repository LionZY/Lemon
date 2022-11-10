//
//  PopPickerView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/26.
//

import SwiftUI

protocol PopupBottomPickerDelegate {
    var picker: PopupPicker? { get set }
}

struct PopupPicker: View {
    @Binding var isPresented: Bool
    @State var isTouchDownButton = false
    
    var type: PickerContentType = .text
    var title: String
    var datas: [String]
    var defaultValue: String
    @State var selectedValue: String
    var didValueChange: ((String, Bool) -> Void)?

    var body: some View {
        VStack {
            titleView()
            Divider().background(Theme.whiteColorA2)
            pickerView()
            Divider().background(Theme.whiteColorA2)
            buttons()
        }
        .background(Theme.blackColor.opacity(0.99).cornerRadius(16.0))
        .shadowedStyle()
        .padding()
        .onChange(of: isPresented, perform: { newValue in
            guard isPresented == false && !isTouchDownButton else { return }
            didValueChange?(defaultValue, false)
        })
    }
    
    @ViewBuilder private func pickerView() -> some View {
        PickerView(datas: datas, selectedValue: defaultValue) { newValue, complete in
            selectedValue = newValue
            didValueChange?(newValue, complete)
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
    }
    
    @ViewBuilder private func titleView() -> some View {
        Text(title)
            .foregroundColor(Theme.whiteColor)
            .font(.system(size: 24))
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
    }
    
    @ViewBuilder private func buttons() -> some View {
        HStack {
            Button {
                isTouchDownButton = true
                isPresented = false
                didValueChange?(defaultValue, true)
            } label: {
                Text("Cancel").frame(maxWidth: .infinity, maxHeight: Theme.normalButtonHeight).font(.system(size: 18)).background(Theme.whiteColorA2.cornerRadius(8.0))
            }
            .buttonStyle(.plain)
            .foregroundColor(Theme.grayColor8)
            Button {
                isTouchDownButton = true
                isPresented = false
                didValueChange?(selectedValue, true)
            } label: {
                Text("Done").frame(maxWidth: .infinity, maxHeight: Theme.normalButtonHeight).font(.system(size: 18)).background(Theme.whiteColorA9.cornerRadius(8.0))
            }
            .buttonStyle(.plain)
            .foregroundColor(Theme.blackColor)
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
    }
}

struct PopupTwoPickers: View {
    @Binding var isPresented: Bool
    @State var isTouchDownButton = false
    
    var type: PickerContentType = .text
    var title: String
    var leftDatas: [String]
    var rightDatas: [String]
    var defaultValue: String
    @State var selectedValue: String
    var didValueChange: ((String, Bool) -> Void)?

    var body: some View {
        VStack {
            titleView()
            Divider().background(Theme.whiteColorA2)
            pickerView()
            Divider().background(Theme.whiteColorA2)
            buttons()
        }
        .background(Theme.blackColor.opacity(0.99).cornerRadius(16.0))
        .shadowedStyle()
        .padding()
        .onChange(of: isPresented, perform: { newValue in
            guard isPresented == false && !isTouchDownButton else { return }
            didValueChange?(defaultValue, false)
        })
    }
    
    @ViewBuilder private func pickerView() -> some View {
        TwoPickerView(leftDatas: leftDatas, rightDatas: rightDatas, splitText: "/", selectedValue: defaultValue) { newValue, complete in
            selectedValue = newValue
            didValueChange?(newValue, complete)
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
    }
    
    @ViewBuilder private func titleView() -> some View {
        Text(title)
            .foregroundColor(Theme.whiteColor)
            .font(.system(size: 24))
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 8, trailing: 16))
    }
    
    @ViewBuilder private func buttons() -> some View {
        HStack {
            Button {
                isTouchDownButton = true
                isPresented = false
                didValueChange?(defaultValue, true)
            } label: {
                Text("Cancel").frame(maxWidth: .infinity, maxHeight: Theme.normalButtonHeight).font(.system(size: 18)).background(Theme.whiteColorA2.cornerRadius(8.0))
            }
            .buttonStyle(.plain)
            .foregroundColor(Theme.grayColor8)
            Button {
                isTouchDownButton = true
                isPresented = false
                didValueChange?(selectedValue, true)
            } label: {
                Text("Done").frame(maxWidth: .infinity, maxHeight: Theme.normalButtonHeight).font(.system(size: 18)).background(Theme.whiteColorA9.cornerRadius(8.0))
            }
            .buttonStyle(.plain)
            .foregroundColor(Theme.blackColor)
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
    }
}

