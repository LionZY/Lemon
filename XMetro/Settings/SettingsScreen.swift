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
        "Build:" + buildVersion + " Version:" + appVersion
    }
    private var listData: [SettingListItem] = [
        .metronome,
        .tuner,
        .about,
    ]
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(listData, id: \.self) { item in
                        NavigationLink(destination: item.destination()) {
                            HStack{
                                Image(systemName: item.icon())
                                Text(item.title())
                            }
                        }
                    }
                }
                Section(footer: VStack {
                    HStack {
                        Spacer()
                        Button("Share XMetro with friends") {
                            isSharePresented = true
                        }
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.white)
                        .sheet(isPresented: $isSharePresented, onDismiss: {
                            print("Dismiss")
                        }, content: {
                            ActivityVC(activityItems: [shareURL])
                        })
                        Spacer()
                    }
                    Text(versionInfo)
                }) {
                    
                }
            }
        }
        .background(.gray)
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
