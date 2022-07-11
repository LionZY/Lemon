//
//  SecondView.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct TunerView: View {
    @State private var selectedValue: String = "Guitar"
    var datas = [["D", "A", "E"], ["G", "B", "E"]]
    var segments = ["Guitar", "Ukulele"]
    
    func lineHeight(_ index: Int) -> Double {
        if index < 50 {
            return 10.0 + 54.0 * (Double(index + 1) / 50.0)
        } else if index == 50 {
            return 84
        } else {
            return 10.0 + 54.0 * (1.0 - Double(index - 50) / 50.0)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Spacer()
                Picker("", selection: $selectedValue) {
                    ForEach(segments, id: \.self) { t in
                        Text(t)
                            .foregroundColor(selectedValue == t ? .red : Color(UIColor(white: 0.0, alpha: 0.3)))
                    }
                }
                .pickerStyle(.segmented)
                Spacer()
                Spacer()
            }
            Spacer()
            HStack{
                Spacer()
                ForEach(0..<101, id: \.self) {
                    Text("")
                        .frame(maxWidth: 1.0, maxHeight: lineHeight($0))
                        .background($0 == 50 ? .red : Color(UIColor(white: 0.0, alpha: 0.3)))
                    Spacer()
                        .frame(maxWidth: 2.0)
                }
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
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

                    }.rotationEffect(.degrees((index + 1) % 2 == 0 ? 6.0 : -6.0))
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("Tuner")
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        TunerView()
    }
}
