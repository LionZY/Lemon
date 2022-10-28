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
            pickerView()
            buttons()
        }
        .background(Color.white.cornerRadius(10.0))
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
        VStack {
            Text(title)
                .foregroundColor(.black)
                .font(.system(size: 24))
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 8, trailing: 16))
            Divider()
        }
    }
    
    @ViewBuilder private func buttons() -> some View {
        HStack {
            Button("Cancel") {
                isTouchDownButton = true
                isPresented = false
                didValueChange?(defaultValue, false)
            }
            .buttonStyle(.plain)
            .font(.system(size: 18))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12.0)
            .foregroundColor(Theme.grayColor8)
            .background(Theme.grayColorF1)
            .cornerRadius(8.0)
            Button("Done") {
                isTouchDownButton = true
                isPresented = false
                didValueChange?(selectedValue, true)
            }
            .buttonStyle(.plain)
            .font(.system(size: 18))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12.0)
            .foregroundColor(.white)
            .background(Theme.blackColor)
            .cornerRadius(8.0)
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
            pickerView()
            buttons()
        }
        .background(Color.white.cornerRadius(10.0))
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
        VStack {
            Text(title)
                .foregroundColor(.black)
                .font(.system(size: 24))
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 8, trailing: 16))
            Divider()
        }
    }
    
    @ViewBuilder private func buttons() -> some View {
        HStack {
            Button("Cancel") {
                isTouchDownButton = true
                isPresented = false
                didValueChange?(defaultValue, false)
            }
            .buttonStyle(.plain)
            .font(.system(size: 18))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12.0)
            .foregroundColor(Theme.grayColor8)
            .background(Theme.grayColorF1)
            .cornerRadius(8.0)
            Button("Done") {
                isTouchDownButton = true
                isPresented = false
                didValueChange?(selectedValue, true)
            }
            .buttonStyle(.plain)
            .font(.system(size: 18))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12.0)
            .foregroundColor(.white)
            .background(Theme.blackColor)
            .cornerRadius(8.0)
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
    }
}

