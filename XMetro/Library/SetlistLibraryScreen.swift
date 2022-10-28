//
//  SetlistScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

struct SetlistLibraryScreen: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("No setlist yet.")
                    .foregroundColor(Theme.grayColorA)
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer().frame(width: 16.0)
                    Button("Add new setlist") {
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: 44.0)
                    .background(Theme.blackColor)
                    .foregroundColor(Theme.whiteColor)
                    .cornerRadius(8.0)
                    Spacer().frame(width: 16.0)
                }
                .font(Font.system(size: 14))
                Spacer().frame(height: 20.0)
            }
        }
        .navigationTitle("Setlist Library")
    }
}

struct SetlistScreen_Previews: PreviewProvider {
    static var previews: some View {
        SetlistLibraryScreen()
    }
}
