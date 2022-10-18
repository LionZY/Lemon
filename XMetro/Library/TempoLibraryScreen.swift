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
    @State var datas = TempoItem.all() ?? []
    @State private var isLoadedPresented: Bool = false
    @State private var manager = TempoRunManager()
    var shouldAutoDismiss: Bool = false
    var didSelectItem:((TempoItem) -> Void)?
    var body: some View {
        VStack {
            contentView()
        }
        .navigationTitle("Tempo Library")
        .popup(isPresented: $isLoadedPresented, type: .toast, position: .top, autohideIn: 2.5) {
            ToastTempoItemUsedInTempo()
        }
    }

    @ViewBuilder func contentView() -> some View {
        if datas.isEmpty {
            empyView()
        } else {
            listView()
        }
    }

    @ViewBuilder func listView() -> some View {
        List {
            ForEach(datas, id: \.self) { item in
                TempoLibraryRow(manager: $manager, item: item)
            }
            .onDelete(perform: delete(at:))
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
        }
    }
}

struct TempoLibraryScreen_Previews: PreviewProvider {
    static var previews: some View {
        TempoLibraryScreen()
    }
}
