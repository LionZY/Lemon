//
//  SecondView.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        HStack {
            VStack {
                Text("Settings Page")
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("Settings")
    }
}

struct FouthView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
