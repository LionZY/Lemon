//
//  SongScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

struct TemposListBackgroundModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

struct TemposList: View {
    @ObservedObject var manager: TempoRunManager
    @State private var datas: [TempoModel] = []
    @State private var selectedItem: TempoModel?
    @State private var isEmpty: Bool = true
    
    private var sortByBPM: Bool {
        TempoSettingsListItem.sortByBPM()
    }
    
    var didSelectItem:((TempoModel) -> Void)?
    var didDeleteItem:((TempoModel) -> Void)?
    
    var body: some View {
        VStack {
            if isEmpty {
                empyView()
            } else {
                listView()
            }
        }
        .onAppear {
            datas = TempoModel.AllItems(sortByBPM: sortByBPM) ?? []
            isEmpty = datas.isEmpty
            manager.register(key: "\(TemposList.self)") {
                datas = TempoModel.AllItems(sortByBPM: sortByBPM) ?? []
                isEmpty = datas.isEmpty
            }
        }
    }

    @ViewBuilder func listView() -> some View {
        List(selection: $selectedItem) {
            Section(footer: Spacer().frame(height: 156.0)) {
                ForEach(datas, id: \.self) { item in
                    TemposListRow(manager: manager, item: item)
                        .listRowBackground(Theme.whiteColor)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
                .onDelete(perform: delete(at:))
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        }
        .onChange(of: selectedItem) { newValue in
            guard let newItem = newValue else { return }
            didSelectItem?(newItem)
            selectedItem = nil
        }
        .animation(.easeInOut, value: datas)
    }
    
    @ViewBuilder func empyView() -> some View {
        Text("No tempo yet.")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.grayColorF1)
            .foregroundColor(Theme.grayColorA)
    }
    
    func delete(at offsets: IndexSet) {
        if let index = offsets.first {
            let willDeleteItem = datas[index]
            willDeleteItem.delete()
            datas.remove(at: index)
            isEmpty = datas.isEmpty
            didDeleteItem?(willDeleteItem)
        }
    }
}