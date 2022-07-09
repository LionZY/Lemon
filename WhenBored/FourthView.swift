//
//  SecondView.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct FourthView: View {
    var body: some View {
        HStack {
            VStack {
                Text("Hello world 4")
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("Fourth Page")
    }
}

struct FouthView_Previews: PreviewProvider {
    static var previews: some View {
        FourthView()
    }
}
