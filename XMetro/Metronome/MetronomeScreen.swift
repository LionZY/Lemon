//
//  HomeView2.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

struct MetronomeScreen: View {
    let store = Store(initialState: MetroActionButtonState(), reducer: MetroActionButtonReducer, environment: MetroActionButtonEnv())
    var body: some View {
        ZStack {
            MetroActionButton(store: store)
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .tint(Theme.mainColor)
            /*
            VStack {
                Spacer()
                HStack {
                    Spacer().frame(width: 16.0)
                    Button("Save to library") {
                        
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
            */
        }
        .navigationTitle("Metronome")
    }
}

struct MetronomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeScreen()
    }
}
