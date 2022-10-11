//
//  SecondView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct AboutScreen: View {
    var body: some View {
        HStack {
            Spacer().frame(width: 20.0)
            VStack {
                Spacer()
                HStack {
                    Spacer().frame(width: 10.0)
                    VStack {
                        Image("icon_small")
                            .frame(width: 80.0, height: 80.0)
                            .cornerRadius(14.0)
                            .shadow(color: Theme.shadowColor, radius: 32.0, x: 0, y: 0)
                        Spacer().frame(height: 30)
                        Text("XMetro is a software for musicians.\nI am also a music lover.\nCause most of the similar apps on the market are not nice to me, I developed this app. I hope it will get better and better in order to serve every musician.")
                            .multilineTextAlignment(.center)
                            .lineSpacing(6.0)
                    }
                    Spacer().frame(width: 8.0)
                }
                .foregroundColor(.gray)
                Spacer()
                HStack {
                    Text("My Github:").foregroundColor(.gray)
                    Link("@LionZY", destination: URL(string: "https://github.com/LionZY")!)
                }
                Spacer().frame(height: 6.0)
                HStack {
                    Text("Contact me:").foregroundColor(.gray)
                    Link("yue_zhang_lion@163.com", destination: URL(string: "mailto://yue_zhang_lion@163.com")!)
                }
                Spacer().frame(height: 20.0)
            }
            Spacer().frame(width: 20.0)
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("About")
    }
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen()
    }
}
