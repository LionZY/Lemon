//
//  Popups.swift
//  Example
//
//  Created by Alex.M on 20.05.2022.
//

import SwiftUI
import ComposableArchitecture

struct PopupMiddle: View {

    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 12) {
            Image("winner")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 226, maxHeight: 226)
            
            Text("Congratulations!")
                .foregroundColor(.black)
                .font(.system(size: 24))
                .padding(.top, 12)
            
            Text("In two weeks, you did 12 workouts and burned 2671 calories. That's 566 calories more than last month. Continue at the same pace and the result will please you.")
                .foregroundColor(.black)
                .font(.system(size: 16))
                .opacity(0.6)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            Button("Thanks") {
                isPresented = false
            }
            .buttonStyle(.plain)
            .font(.system(size: 18, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 24)
            .foregroundColor(.white)
            .background(Color(hex: "9265F8"))
            .cornerRadius(12)
        }
        .padding(EdgeInsets(top: 37, leading: 24, bottom: 40, trailing: 24))
        .background(Color.white.cornerRadius(20))
        .shadowedStyle()
        .padding(.horizontal, 40)
    }
}


protocol PopupBottomPickerDelegate {
    var picker: PopupBottomPicker? { get set }
}

struct PopupBottomPicker: View {
    @Binding var isPresented: Bool
    @State var isTouchDownButton = false
    var type: PickerContentType = .text
    var title: String
    var datas: [String]
    var defaultValue: String
    var selectedValue: String
    var didValueChange: ((String, Bool) -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .foregroundColor(.black)
                .font(.system(size: 24))
            PickerView(datas: datas, selectedValue: defaultValue, didValueChanged: didValueChange)
            HStack {
                Button("Cancel") {
                    isTouchDownButton = true
                    isPresented = false
                    didValueChange?(defaultValue, false)
                }
                .buttonStyle(.plain)
                .font(.system(size: 18))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .foregroundColor(.white)
                .background(Theme.lightColor)
                .cornerRadius(12)
                Button("Done") {
                    isTouchDownButton = true
                    isPresented = false
                    didValueChange?(selectedValue, true)
                }
                .buttonStyle(.plain)
                .font(.system(size: 18))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .foregroundColor(.white)
                .background(Theme.mainColor)
                .cornerRadius(12)
            }
        }
        .onChange(of: isPresented, perform: { newValue in
            if isPresented == false && !isTouchDownButton {
                didValueChange?(defaultValue, false)
            }
        })
        .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24))
        .background(Color.white.cornerRadius(20))
        .shadowedStyle()
        .padding(.horizontal, 16)
    }
}

struct PopupBottomSecond: View {

    var body: some View {
        VStack(spacing: 12) {
            Image("chest")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 156, maxHeight: 156)
            
            Text("Personal offer")
                .foregroundColor(.black)
                .font(.system(size: 24))
                .padding(.top, 4)
            
            Text("Say hello to flexible funding – you're pre-screened for an exclusive personal loan offer through TD Bank. Enter your Personal Offer Code to get started.")
                .foregroundColor(.black)
                .font(.system(size: 16))
                .opacity(0.6)
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)
            
            Text("Read More")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "3DDCFF"), Color(hex: "CD3DFF")]),
                        startPoint: .top,
                        endPoint: .bottom))
                .cornerRadius(12)
                .foregroundColor(.white)
                .padding(.horizontal, 64)
        }
        .padding(EdgeInsets(top: 37, leading: 24, bottom: 40, trailing: 24))
        .background(Color.white.cornerRadius(20))
        .shadowedStyle()
    }
}


struct Popups_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
            PopupMiddle(isPresented: .constant(true))
        }
        
        ZStack {
            Rectangle()
                .ignoresSafeArea()
            PopupBottomPicker(isPresented: .constant(false), title: "123", datas: ["123"], defaultValue: "123", selectedValue: "123")
        }
        
        ZStack {
            Rectangle()
                .ignoresSafeArea()
            PopupBottomSecond()
        }
    }
}