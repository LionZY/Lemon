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
    ]
    var body: some View {
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