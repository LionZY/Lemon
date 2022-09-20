//
//  SecondView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        HStack {
            VStack {
                Text("XMetro is developed by @LionZY")
                Link("Github", destination: URL(string: "https://github.com/LionZY")!)
                    .buttonStyle(.bordered)
                    .foregroundColor(.black)
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("About")
    }
}

struct FouthView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
