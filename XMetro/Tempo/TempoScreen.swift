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
    @State private var isSubdivisionPresented: Bool = false
    @State private var isSoundEffectPresented: Bool = false
    @State private var isSaveSucessPresented: Bool = false
    
    @State private var tempoComesFromDB: Bool = false
    
    var body: some View {
        mainView()
        .navigationTitle("Tempo")
        .popups(
            manager,
            $isTimeSignaturePresented,
            $isBPMPresented,
            $isSubdivisionPresented,
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
        _ isSubdivisionPresented: Binding<Bool>,
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
            PopupBottomPicker(
                isPresented: isTimeSignaturePresented,
                title: "Time Signature",
                datas: meterSet,
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
            PopupBottomPicker(
                isPresented: isBPMPresented,
                title: "BPM",
                datas: bpmSet,
                defaultValue: "\(manager.tempoItem.bpm)",
                selectedValue: "\(manager.tempoItem.bpm)",
                didValueChange: action
            )
        }
        .popup(isPresented: isSubdivisionPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .clear) {
            let action: ((String, Bool) -> Void) = { newValue, complete in
                manager.tempoItem.subDivision = newValue
                manager.notifyListeners()
            }
            PopupBottomPicker(
                isPresented: isSubdivisionPresented,
                title: "Subdivision",
                datas: subdivisionSet,
                defaultValue: manager.tempoItem.subDivision,
                selectedValue: manager.tempoItem.subDivision,
                didValueChange: action
            )
        }
        .popup(isPresented: isSoundEffectPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .clear) {
            let action: ((String, Bool) -> Void) = { newValue, complete in
                manager.tempoItem.soundEffect = newValue
                PlayerManager.recreatePlayers(manager: manager)
                manager.notifyListeners()
            }
            PopupBottomPicker(
                isPresented: isSoundEffectPresented,
                title: "Sound Effect",
                datas: soundSet,
                defaultValue: manager.tempoItem.soundEffect,
                selectedValue: manager.tempoItem.soundEffect,
                didValueChange: action
            )
        }
        .popup(isPresented: isSaveSucessPresented, type: .toast, position: .top, autohideIn: 2.5) {
            ToastTempoItemSaved()
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
            manager.tempoItem = .init()
            manager.notifyListeners()
        }

        let didSelectItem: ((TempoModel) -> Void) = { selectedTempo in
            manager.tempoItem = selectedTempo
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
            VStack {
                HStack {
                    meterButton()
                    bpmButton()
                    soundButton()
                    Spacer()
                    dotsView()
                    Spacer()
                    actionButton()
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 4, trailing: 16))
                playButton()
            }
            .background(Theme.whiteColor)
            .cornerRadius(8.0)
            .shadow(color: Theme.lightGrayColor, radius: 12.0)
            .padding()
        }
    }
    
    @ViewBuilder private func playButton() -> some View {
        HStack {
            if tempoComesFromDB {
                Button {
                    manager.stop()
                    manager.tempoItem = .init()
                    manager.notifyListeners()
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Theme.lightColor)
                        .foregroundColor(Theme.whiteColor)
                        .cornerRadius(8.0)
                }
                .frame(maxWidth: .infinity, maxHeight: 48.0)
            }
            
            Button {
                manager.stop()
                manager.tempoItem.replace()
                manager.tempoItem = .init()
                manager.notifyListeners()
                isSaveSucessPresented = true
            } label: {
                Text(tempoComesFromDB ? "Update" : "Save to list")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Theme.mainColor)
                    .foregroundColor(Theme.whiteColor)
                    .cornerRadius(8.0)
            }
            .frame(maxWidth: .infinity, maxHeight: 48.0)
        }
        .font(Font.system(size: 16))
        .padding(EdgeInsets(top: 4, leading: 16, bottom: 16, trailing: 16))
    }
    
    @ViewBuilder private func actionButton() -> some View {
        TempoRunButton(
            manager: $manager,
            tempo: manager.tempoItem,
            style: .global
        )
        .frame(maxWidth: 50.0, maxHeight: 50, alignment: .center)
        .cornerRadius(25.0)
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
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }

    @ViewBuilder private func bpmButton() -> some View {
        Button(bpm) {
            isBPMPresented = true
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private func subDivisionButton() -> some View {
        Button(subdivision) {
            isSubdivisionPresented = true
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private func soundButton() -> some View {
        Button(soundEffect) {
            isSoundEffectPresented = true
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
}
