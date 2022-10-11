//
//  SecondView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct SettingsScreen: View {
    @State private var isSharePresented: Bool = false
    private let shareURL = URL(string: "https://apps.apple.com/app/6443442078")!
    private let infoDictionary = Bundle.main.infoDictionary
    private var appVersion: String {
        (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    private var buildVersion: String {
        (infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
    private var versionInfo: String {
        "Build: " + buildVersion + "\nVersion: " + appVersion
    }
    private var listData: [SettingListItem] = [
        .metronome,
        .tuner,
        .about,
    ]
    var body: some View {
        ZStack {
            List {
                Section {
                    ForEach(listData, id: \.self) { item in
                        item.itemView()
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer().frame(width: 16.0)
                    Button("Share XMetro with friends") {
                        isSharePresented = true
                    }
                    .frame(maxWidth: .infinity, maxHeight: 44.0)
                    .background(Theme.mainColor)
                    .foregroundColor(Theme.whiteColor)
                    .cornerRadius(8.0)
                    .sheet(isPresented: $isSharePresented, onDismiss: {
                        print("Dismiss")
                    }, content: {
                        ActivityVC(activityItems: [shareURL])
                    })
                    Spacer().frame(width: 16.0)
                }
                .font(Font.system(size: 14))
                Spacer().frame(height: 10.0)
                Text(versionInfo)
                    .multilineTextAlignment(.center)
                    .font(Font.system(size: 12))
                    .foregroundColor(Theme.grayColor)
                Spacer().frame(height: 20.0)
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
