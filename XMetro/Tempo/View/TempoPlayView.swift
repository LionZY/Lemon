//
//  TempoPlayView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/11/3.
//

import SwiftUI

struct TempoPlayView: View {
    @ObservedObject var manager: TempoRunManager
    @State private var showButtons: Bool = false
    @State private var fromDB: Bool = false
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                HStack {
                    actionButton()
                    VStack(alignment: .leading, spacing: 0) {
                        dotsView()
                        Spacer().frame(height: 12.0)
                        editButtons()
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                Divider()
                bottomButtons()
            }
            .background(
                Theme.redColor
                    .cornerRadius(12.0)
                    .shadow(color: Theme.grayColorA, radius: 4.0)
            )
            .padding()
        }
        .onAppear {
            fromDB = isCurrentTempoFromDB()
            manager.register(key: "\(TempoPlayView.self)") {
                fromDB = isCurrentTempoFromDB()
            }
        }
        .animation(.easeInOut, value: showButtons)
        .animation(.easeInOut, value: fromDB)
    }
    
    @ViewBuilder private func actionButton() -> some View {
        TempoRunButton(
            manager: manager,
            tempoId: manager.state.tempoItem.uid,
            style: .global
        )
        .frame(maxWidth: Theme.largeButtonHeight, maxHeight: Theme.largeButtonHeight, alignment: .center)
        .cornerRadius(8.0)
        .onTapGesture {
            manager.nextAction()
        }
    }

    @ViewBuilder private func editButtons() -> some View {
        HStack {
            ForEach(TempoEditAction.uiCases(), id: \.self) { action in
                if action == .none {
                    Spacer().frame(width: 8.0)
                } else {
                    TempoEditButton(manager: manager, type: action)
                }
            }
        }
    }
    
    @ViewBuilder private func dotsView() -> some View {
        HStack {
            TempoDotsView(
                manager: manager,
                tempoId: manager.state.tempoItem.uid,
                style: .global
            )
            Spacer()
            Image(systemName: fromDB ? "list.dash.header.rectangle" : "pencil.circle").foregroundColor(Theme.whiteColor)
        }
    }
    
    @ViewBuilder private func bottomButtons() -> some View {
        HStack {
            if showButtons {
                if fromDB { resetButton() }
                cancelButton()
                saveButton()
            } else {
                switchButton()
            }
        }
        .padding(EdgeInsets(top: showButtons ? 12.0 : 4, leading: 16, bottom: showButtons ? 12.0 : 4, trailing: 16))
    }
    
    @ViewBuilder private func resetButton() -> some View {
        Button {
            manager.stop()
            manager.state.tempoItem = .init()
            manager.tabbar?.pop(type: .reverted, value: true)
        } label: {
            Text("Reset")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Theme.whiteColorA2)
                .foregroundColor(Theme.whiteColor)
                .cornerRadius(8.0)
        }
        .frame(maxWidth: .infinity, maxHeight: Theme.normalButtonHeight)
    }
    
    @ViewBuilder private func cancelButton() -> some View {
        Button {
            showButtons = false
        } label: {
            Text("Cancel")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Theme.whiteColorA2)
                .foregroundColor(Theme.whiteColor)
                .cornerRadius(8.0)
        }
        .frame(maxWidth: .infinity, maxHeight: Theme.normalButtonHeight)
    }
    
    @ViewBuilder private func saveButton() -> some View {
        Button {
            manager.stop()
            manager.state.tempoItem.replace()
            manager.state.tempoItem = .init()
            manager.tabbar?.pop(type: .saveSuccess, value: true)
            manager.notifyListeners()
            showButtons = true
        } label: {
            Text(fromDB ? "Update" : "Save to list")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Theme.blackColor)
                .foregroundColor(Theme.whiteColor)
                .cornerRadius(8.0)
        }
        .frame(maxWidth: .infinity, maxHeight: Theme.normalButtonHeight)
    }
    
    @ViewBuilder private func switchButton() -> some View {
        Button {
            showButtons = true
        } label: {
            Image(systemName: "line.3.horizontal")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(Theme.whiteColor)
        }
        .frame(maxWidth: .infinity, maxHeight: Theme.normalButtonHeight)
    }
    
    private func isCurrentTempoFromDB() -> Bool {
        let currentTempo = manager.state.tempoItem
        let tempoFromDB = TempoModel.one(uid: currentTempo.uid)
        return tempoFromDB != nil
    }
    
    private func needShowButtons() -> Bool {
        let currentTempo = manager.state.tempoItem
        let tempoFromDB = TempoModel.one(uid: currentTempo.uid)
        if fromDB { return tempoFromDB != currentTempo }
        return fromDB
    }
}
