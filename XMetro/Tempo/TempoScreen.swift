//
//  HomeView2.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture
import PopupView

struct TempoScreen: View {
    @ObservedObject var manager: TempoRunManager
    var body: some View {
        mainView()
            .navigationTitle("Tempo")
            .onWillAppear {
                manager.stop()
            }
            .onWillDisappear {
                manager.stop()
            }
    }
}

extension TempoScreen {
    // MARK: - View builders -
    @ViewBuilder private func mainView() -> some View {
        ZStack {
            listView()
            TempoPlayView(manager: manager)
        }
    }
    
    @ViewBuilder private func listView() -> some View {
        let didDeleteItem: ((TempoModel) -> Void)  = { deletedTempo in
            manager.tabbar?.pop(type: .reverted, value: true)
            if deletedTempo.uid == manager.state.tempoItem.uid {
                manager.stop()
                manager.state.tempoItem = .init()
            }
            manager.notifyListeners()
        }

        let didSelectItem: ((TempoModel) -> Void) = { selectedTempo in
            if manager.isRunning || manager.isCountDown { manager.stop() }
            if manager.state.tempoItem == selectedTempo {
                manager.tabbar?.pop(type: .reverted, value: true)
                manager.state.tempoItem = .init()
            } else {
                manager.state.tempoItem = selectedTempo
                manager.nextAction()
            }
            manager.notifyListeners()
        }

        TemposList(
            manager: manager,
            didSelectItem: didSelectItem,
            didDeleteItem: didDeleteItem
        )
    }
}
