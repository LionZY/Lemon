//
//  SecondView.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct SecondView: View {
    @State private var selectedValue: Int = 0
    var datas = [["D", "A", "E"], ["G", "B", "E"]]
    var body: some View {
        VStack {
            Picker("", selection: $selectedValue) {
                ForEach(["Guitar", "Ukulele"], id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            
            HStack {
                ForEach(datas.indices, id: \.self) { index in
                    let subItems = datas[index]
                    VStack {
                        ForEach(subItems, id: \.self) { item in
                            Button(item) {
                                
                            }
                            .frame(maxWidth: 60, maxHeight: 60)
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(30.0)
                        }

                    }.rotationEffect(.degrees((index + 1) % 2 == 0 ? -6.0 : 6.0))
                }
                Spacer()
                Spacer()
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("Tuner")
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}
