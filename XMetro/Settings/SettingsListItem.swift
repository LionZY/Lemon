//
//  SettingsListItem.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

enum SettingListItem: Hashable {
    case metronome
    case tuner
    case about
    case update
    
    func icon() -> String {
        switch self {
        case .metronome: return "metronome"
        case .tuner: return "tuningfork"
        case .about: return "info.circle"
        case .update: return "star.circle"
        }
    }
    
    func title() -> String {
        switch self {
        case .metronome: return "Tempo settings"
        case .tuner: return "Tuner settings"
        case .about: return "About Ting"
        case .update: return "Rate us"
        }
    }
    
    @ViewBuilder func destination() -> some View {
        switch self {
        case .metronome: TempoSettingsScreen()
        case .tuner: TunerSettingsScreen()
        case .about: AboutScreen()
        case .update: EmptyView()
        }
    }
    
    @ViewBuilder func itemView() -> some View {
        if self == .update {
            HStack{
                Image(systemName: icon())
                Text(title())
                Spacer()
                Button(" App Store ") {
                    if let url = URL(string: "https://apps.apple.com/app/6443442078") {
                        UIApplication.shared.open(url)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .font(.system(size: 14.0))
                .tint(Theme.grayColorF1)
                .foregroundColor(Theme.blackColor)
            }
        } else {
            NavigationLink(destination: destination()) {
                HStack{
                    Image(systemName: icon())
                    Text(title())
                }
            }
        }
    }
}
