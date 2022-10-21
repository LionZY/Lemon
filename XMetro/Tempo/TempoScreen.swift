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
    
    @State private var unsavedTempo: TempoModel?
    @State private var manager: TempoRunManager = .init()
    
    @State private var timeSignature: String = "\(TempoModel.meter)/\(TempoModel.devide)"
    @State private var bpm: String = "\(TempoModel.bpm)"
    @State private var subdivision: String = "\(TempoModel.subdivision)"
    @State private var soundEffect: String = "\(TempoModel.soundEffect)"
    
    @State private var isTimeSignaturePresented: Bool = false
    @State private var isBPMPresented: Bool = false
    @State private var isSubdivisionPresented: Bool = false
    @State private var isSoundEffectPresented: Bool = false
    @State private var isSaveSucessPresented: Bool = false
    @State private var fromDB: Bool = false
    
    private var updateKey = "TempoScreen"
    
    init() {
        unsavedTempo = manager.tempoItem
    }

    var body: some View {
        VStack {
            Spacer()
            actionButton()
            Spacer()
            dotsView()
            Spacer()
            VStack {
                HStack(spacing: 10.0) {
                    Spacer()
                    meterButton()
                    bpmButton()
                    soundButton()
                    Spacer()
                }
                if fromDB {
                    Spacer().frame(height: 12.0)
                    Text("This tempo comes from the library.")
                        .foregroundColor(Theme.lightGrayColor)
                        .font(.system(size: 12))
                }
            }
            Spacer()
        }
        .navigationTitle("Tempo")
        .navigationBarItems(leading: nagivationLeftView())
        .navigationBarItems(trailing: navigationRightView())
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
            manager.register(key: updateKey) {
                timeSignature = "\(manager.tempoItem.meter)/\(manager.tempoItem.devide)"
                bpm = "\(manager.tempoItem.bpm)"
                subdivision = manager.tempoItem.subDivision
                soundEffect = manager.tempoItem.soundEffect
                
                // 数据不是来自数据去的情况下
                if fromDB == false {
                    manager.tempoItem.saveToUserDefaults()
                }
            }
        }
        .animation(.easeInOut, value: fromDB)
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
    @ViewBuilder private func actionButton() -> some View {
        TempoRunButton(manager: $manager, tempo: manager.tempoItem, style: .large)
            .frame(maxWidth: 200, maxHeight: 200, alignment: .center)
            .cornerRadius(100)
            .shadow(color: Theme.shadowColor, radius: 28.0, x: 0, y: 0)
            .onTapGesture {
                manager.nextAction()
            }
    }

    @ViewBuilder private func dotsView() -> some View {
        TempoDotsView(manager: $manager)
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
    
    @ViewBuilder private func nagivationLeftView() -> some View {
        if fromDB {
            Button("Cancel") {
                manager.stop()
                manager.tempoItem = unsavedTempo ?? .init()
                fromDB = false
                manager.notifyListeners()
            }
            .foregroundColor(Theme.lightColor)
        } else {
            NavigationLink(
                "Import",
                destination: TempoLibraryScreen(
                    shouldAutoDismiss: true,
                    didSelectItem:  { newTempo in
                        unsavedTempo = manager.tempoItem
                        manager.tempoItem = newTempo
                        fromDB = true
                        manager.notifyListeners()
                    }
                )
            )
            .foregroundColor(Theme.mainColor)
        }
    }
    
    @ViewBuilder private func navigationRightView() -> some View {
        HStack {
            Button(fromDB ? "Update" : "Save") {
                manager.tempoItem.replace()
                manager.tempoItem = unsavedTempo ?? .init()
                isSaveSucessPresented = true
                fromDB = false
                manager.notifyListeners()
            }
            .foregroundColor(Theme.mainColor)
        }
    }
}
