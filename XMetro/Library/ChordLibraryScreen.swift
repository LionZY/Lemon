//
//  ChordScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

struct ChordLibraryScreen: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("No chord yet.")
                    .foregroundColor(Theme.grayColor)
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer().frame(width: 16.0)
                    Button("Add new chord") {
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: 44.0)
                    .background(Theme.mainColor)
                    .foregroundColor(Theme.whiteColor)
                    .cornerRadius(8.0)
                    Spacer().frame(width: 16.0)
                }
                .font(Font.system(size: 14))
                Spacer().frame(height: 20.0)
            }
        }
        .navigationTitle("Chord Library")
    }
}

struct ChordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChordLibraryScreen()
    }
}
