//
//  SecondView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import Foundation
import SwiftUI

struct SettingsScreen: View {
    private let infoDictionary = Bundle.main.infoDictionary
    private var appVersion: String {
        (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    private var buildVersion: String {
        (infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
    private var footerInfo: String {
        "Build:" + buildVersion + " Version:" + appVersion
    }
    private var listData: [SettingListItem] = [
        SettingListItem(icon: "info.circle", title: "About XMetro")
    ]
    var body: some View {
        VStack {
            List {
                Section(footer: HStack {
                    Spacer()
                    Text(footerInfo)
                    Spacer()
                }) {
                    ForEach(listData, id: \.self) { item in
                        NavigationLink(destination: AboutScreen()) {
                            HStack{
                                Image(systemName: item.icon)
                                Text(item.title)
                            }
                        }
                    }
                }
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
