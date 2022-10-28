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
    @State private var manager: TempoRunManager = .init()
    
    @State private var timeSignature: String = "\(4)/\(4)"
    @State private var bpm: String = "\(60)"
    @State private var subdivision: String = ""
    @State private var soundEffect: String = "Default"
    
    @State private var isTimeSignaturePresented: Bool = false
    @State private var isBPMPresented: Bool = false
    @State private var isRevertedToDefault: Bool = false
    @State private var isSoundEffectPresented: Bool = false
    @State private var isSaveSucessPresented: Bool = false
    
    @State private var showBottomButtons: Bool = false
    @State private var tempoComesFromDB: Bool = false
    
    var body: some View {
        mainView()
            .navigationTitle("Tempo")
            .popups(
                manager,
                $isTimeSignaturePresented,
                $isBPMPresented,
                $isRevertedToDefault,
                $isSoundEffectPresented,
                $isSaveSucessPresented
            )
            .onWillDisappear {
                manager.stop()
            }
            .onWillAppear {
                manager.register(key: "\(TempoScreen.self)") {
                    timeSignature = "\(manager.tempoItem.meter)/\(manager.tempoItem.devide)"
                    bpm = "\(manager.tempoItem.bpm)"
                    subdivision = manager.tempoItem.subDivision
                    soundEffect = manager.tempoItem.soundEffect
                    tempoComesFromDB = TempoModel.one(uid: manager.tempoItem.uid) != nil
                }
            }
            .animation(.easeInOut, value: tempoComesFromDB)
            .animation(.easeInOut, value: manager.tempoItem)
            .animation(.easeInOut, value: showBottomButtons)
    }
}

struct TempoScreen_Previews: PreviewProvider {
    static var previews: some View {
        TempoScreen()
    }
}

extension View {
    func popups(
        _ manager: TempoRunManager,
        _ isTimeSignaturePresented: Binding<Bool>,
        _ isBPMPresented: Binding<Bool>,
        _ isRevertedToDefault: Binding<Bool>,
        _ isSoundEffectPresented: Binding<Bool>,
        _ isSaveSucessPresented: Binding<Bool>
    ) -> some View {
        self.popup(isPresented: isTimeSignaturePresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .clear) {
            let action: ((String, Bool) -> Void) = { newValue, complete in
                let components = newValue.components(separatedBy: "/")
                let newMeter = Int(components.first ?? "4") ?? 4
                let newDevide = Int(components.last ?? "4") ?? 4
                manager.tempoItem.meter = newMeter
                manager.tempoItem.devide = newDevide
                manager.notifyListeners()
            }
            PopupTwoPickers(
                isPresented: isTimeSignaturePresented,
                title: "Time Signature",
                leftDatas: meterSet,
                rightDatas: devideSet,
                defaultValue: "\(manager.tempoItem.meter)/\(manager.tempoItem.devide)",
                selectedValue: "\(manager.tempoItem.meter)/\(manager.tempoItem.devide)",
                didValueChange: action
            )
        }
        .popup(isPresented: isBPMPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .clear) {
            let action: ((String, Bool) -> Void) = { newValue, complete in
                let newBPM = Int(newValue) ?? 60
                manager.tempoItem.bpm = newBPM
                manager.notifyListeners()
                if manager.isCountDownStoped { manager.run() }
            }
            PopupPicker(
                isPresented: isBPMPresented,
                title: "BPM",
                datas: bpmSet,
                defaultValue: "\(manager.tempoItem.bpm)",
                selectedValue: "\(manager.tempoItem.bpm)",
                didValueChange: action
            )
        }
        .popup(isPresented: isSoundEffectPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .clear) {
            let action: ((String, Bool) -> Void) = { newValue, complete in
                manager.tempoItem.soundEffect = newValue
                PlayerManager.recreatePlayers(manager: manager)
                manager.notifyListeners()
            }
            PopupPicker(
                isPresented: isSoundEffectPresented,
                title: "Sound Effect",
                datas: soundSet,
                defaultValue: manager.tempoItem.soundEffect,
                selectedValue: manager.tempoItem.soundEffect,
                didValueChange: action
            )
        }
        .popup(isPresented: isSaveSucessPresented, type: .toast, position: .top, autohideIn: 1.5) {
            ToastTempoItemSaved()
        }
        .popup(isPresented: isRevertedToDefault, type: .toast, position: .top, autohideIn: 1.5) {
            ToastTempoResumeToDefault()
        }
    }
}

extension TempoScreen {
    // MARK: - View builders -
    @ViewBuilder private func mainView() -> some View {
        ZStack {
            listView()
            tempoPlayView()
        }
    }
    
    @ViewBuilder private func listView() -> some View {
        let didDeleteItem: ((TempoModel) -> Void)  = { deletedTempo in
            isRevertedToDefault = true
            manager.tempoItem = .init()
            manager.notifyListeners()
        }

        let didSelectItem: ((TempoModel) -> Void) = { selectedTempo in
            if manager.isRunning || manager.isCountDown { manager.stop() }
            if manager.tempoItem == selectedTempo {
                isRevertedToDefault = true
                manager.tempoItem = .init()
            } else {
                manager.tempoItem = selectedTempo
                manager.nextAction()
            }
            manager.notifyListeners()
        }

        TemposList(
            manager: $manager,
            didSelectItem: didSelectItem,
            didDeleteItem: didDeleteItem
        )
    }
    
    @ViewBuilder private func tempoPlayView() -> some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                HStack {
                    actionButton()
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            dotsView()
                            Spacer()
                            let iconName = tempoComesFromDB ? "list.dash.header.rectangle" : "pencil.circle"
                            Image(systemName: iconName).foregroundColor(Theme.whiteColor)
                        }
                        Spacer().frame(height: 12.0)
                        HStack() {
                            bpmButton()
                            Spacer()
                            meterButton()
                            Spacer()
                            soundButton()
                        }
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
    }
    
    @ViewBuilder private func bottomButtons() -> some View {
        HStack {
            if showBottomButtons {
                if tempoComesFromDB {
                    Button {
                        manager.stop()
                        manager.tempoItem = .init()
                        manager.notifyListeners()
                        showBottomButtons = false
                        isRevertedToDefault = true
                    } label: {
                        Text("Reset")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Theme.whiteColorA2)
                            .foregroundColor(Theme.whiteColor)
                            .cornerRadius(8.0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 44.0)
                }
                Button {
                    showBottomButtons = false
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Theme.whiteColorA2)
                        .foregroundColor(Theme.whiteColor)
                        .cornerRadius(8.0)
                }
                .frame(maxWidth: .infinity, maxHeight: 44.0)
                Button {
                    manager.stop()
                    manager.tempoItem.replace()
                    manager.tempoItem = .init()
                    manager.notifyListeners()
                    isSaveSucessPresented = true
                    showBottomButtons = false
                } label: {
                    Text(tempoComesFromDB ? "Update" : "Save to list")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Theme.blackColor)
                        .foregroundColor(Theme.whiteColor)
                        .cornerRadius(8.0)
                }
                .frame(maxWidth: .infinity, maxHeight: 44.0)
            } else {
                Button {
                    showBottomButtons = true
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(Theme.whiteColor)
                }
                .frame(maxWidth: .infinity, maxHeight: 44.0)
            }
        }
        .padding(EdgeInsets(top: showBottomButtons ? 12.0 : 4, leading: 16, bottom: showBottomButtons ? 12.0 : 4, trailing: 16))
    }
    
    @ViewBuilder private func actionButton() -> some View {
        TempoRunButton(
            manager: $manager,
            tempo: manager.tempoItem,
            style: .global
        )
        .frame(maxWidth: 68, maxHeight: 68, alignment: .center)
        .cornerRadius(8.0)
        .onTapGesture {
            manager.nextAction()
        }
    }

    @ViewBuilder private func dotsView() -> some View {
        TempoDotsView(
            manager: $manager,
            tempo: manager.tempoItem,
            style: .global
        )
    }
    
    @ViewBuilder private func meterButton() -> some View {
        Button(timeSignature) {
            isTimeSignaturePresented = true
        }
        .tint(Theme.grayColorF1)
        .foregroundColor(Theme.whiteColor)
        .controlSize(.regular)
        .buttonStyle(.bordered)
    }

    @ViewBuilder private func bpmButton() -> some View {
        Button(bpm) {
            isBPMPresented = true
        }
        .tint(Theme.grayColorF1)
        .foregroundColor(Theme.whiteColor)
        .controlSize(.regular)
        .buttonStyle(.bordered)
    }
    
    @ViewBuilder private func soundButton() -> some View {
        Button(soundEffect) {
            isSoundEffectPresented = true
        }
        .tint(Theme.grayColorF1)
        .foregroundColor(Theme.whiteColor)
        .controlSize(.regular)
        .buttonStyle(.bordered)
    }
}
