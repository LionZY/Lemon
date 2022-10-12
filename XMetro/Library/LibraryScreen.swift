//
//  LibraryScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/10.
//

import SwiftUI

struct LibraryScreen: View {
    private var listData: [LibraryListItem] = [
        .tempo,
        .setlist
    ]
    var body: some View {
        ZStack {}
        VStack {
            List {
                Section {
                    ForEach(listData, id: \.self) { item in
                        item.itemView()
                    }
                }
            }
        }
        .navigationTitle("Library")
    }
}

struct LibraryScreen_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScreen()
    }
}
