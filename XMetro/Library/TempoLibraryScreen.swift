//
//  SongScreen.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI
import PopupView

struct TempoLibraryScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var datas = TempoModel.AllItems() ?? []
    @State private var isLoadedPresented: Bool = false
    @State private var manager = TempoRunManager()
    @State private var selectedItem: TempoModel?
    @State private var isEmpty: Bool = true
    var shouldAutoDismiss: Bool = false
    var didSelectItem:((TempoModel) -> Void)?
    
    var body: some View {
        VStack {
            if isEmpty { empyView() }
            else { listView() }
        }
        .navigationTitle("Tempo Library")
        .popup(isPresented: $isLoadedPresented, type: .toast, position: .top, autohideIn: 2.5) {
            ToastTempoItemUsedInTempo()
        }
        .onWillAppear {
            datas = TempoModel.AllItems() ?? []
            isEmpty = datas.isEmpty
        }
        .onWillDisappear {
            manager.stop()
        }
    }

    @ViewBuilder func listView() -> some View {
        List(selection: $selectedItem) {
            ForEach(datas, id: \.self) { item in
                TempoLibraryRow(manager: $manager, item: item)
            }
            .onDelete {
                delete(at: $0)
            }
        }.onChange(of: selectedItem) { newValue in
            guard let newItem = newValue else { return }
            didSelectItem?(newItem)
            guard shouldAutoDismiss else { return }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @ViewBuilder func empyView() -> some View {
        Text("No tempo yet.").foregroundColor(Theme.grayColor)
    }
    
    @ViewBuilder func addButton() -> some View {
        if shouldAutoDismiss {
            HStack {
                Spacer().frame(width: 16.0)
                Button("Add new tempo") { }
                .frame(maxWidth: .infinity, maxHeight: 44.0)
                .background(Theme.mainColor)
                .foregroundColor(Theme.whiteColor)
                .cornerRadius(8.0)
                Spacer().frame(width: 16.0)
            }
            .font(Font.system(size: 14))
        } else {
            EmptyView().frame(height: 0.0)
        }
    }
    
    func delete(at offsets: IndexSet) {
        if let index = offsets.first {
            datas[index].delete()
            datas.remove(at: index)
            isEmpty = datas.isEmpty
        }
    }
}

struct TempoLibraryScreen_Previews: PreviewProvider {
    static var previews: some View {
        TempoLibraryScreen()
    }
}
