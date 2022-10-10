//
//  SecondView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct AboutScreen: View {
    @State private var isSharePresented: Bool = false
    private let shareURL = URL(string: "https://apps.apple.com/app/6443442078")!
    var body: some View {
        HStack {
            Spacer().frame(width: 20.0)
            VStack {
                Image("icon_show")
                    .frame(width: 100.0, height: 100.0)
                    .cornerRadius(17.6)
                    .shadow(color: .gray, radius: 40.0, x: 0, y: 0)
                Spacer().frame(minHeight: 0, maxHeight: 84.0)
                HStack {
                    Text("Developed by")
                    Link("@LionZY", destination: URL(string: "https://github.com/LionZY")!)
                }
                Spacer().frame(minHeight: 0, maxHeight: 12.0)
                Button("Share XMetro with friends") {
                    self.isSharePresented = true
                }
                .buttonStyle(.borderedProminent)
                .background(.black)
                .foregroundColor(.white)
                .cornerRadius(8.0)
                .sheet(isPresented: $isSharePresented, onDismiss: {
                    print("Dismiss")
                }, content: {
                    ActivityVC(activityItems: [shareURL])
                })
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
