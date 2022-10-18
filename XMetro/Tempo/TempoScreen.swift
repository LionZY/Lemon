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
    @State private var timeSignature: String = "\(TempoItem.meter)/\(TempoItem.devide)"
    @State private var bpm: String = "\(TempoItem.bpm)"
    @State private var isTimeSignaturePresented: Bool = false
    @State private var isBPMPresented: Bool = false
    @State private var isSubdivisionPresented: Bool = false
    @State private var isSoundEffectPresented: Bool = false
    @State private var isSaveSucessPresented: Bool = false
    private var updateKey = "\(TempoScreen.self)"
    
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
                    Spacer()
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
        .onAppear {
            manager.register(key: updateKey) {
                timeSignature = "\(TempoItem.meter)/\(TempoItem.devide)"
                bpm = "\(TempoItem.bpm)"
            }
        }
        .onDisappear {
            manager.stop()
            manager.remove(key: updateKey)
        }
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
                manager.tempoItem.meter = Int(components.first ?? "4") ?? 4
                manager.tempoItem.devide = Int(components.last ?? "4") ?? 4
                manager.notifyListeners()
            }
            PopupBottomPicker(
                isPresented: isTimeSignaturePresented,
                title: "Time Signature",
                datas: meterSet,
                defaultValue: "\(TempoItem.meter)/\(TempoItem.devide)",
                selectedValue: "\(manager.tempoItem.meter)/\(manager.tempoItem.devide)",
                didValueChange: action
            )
        }
        .popup(isPresented: isBPMPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .clear) {
            let action: ((String, Bool) -> Void) = { newValue, complete in
                manager.tempoItem.bpm = Int(newValue) ?? 60
                manager.notifyListeners()
                if manager.isCountDownStoped { manager.run() }
            }
            PopupBottomPicker(
                isPresented: isBPMPresented,
                title: "BPM",
                datas: bpmSet,
                defaultValue: "\(TempoItem.bpm)",
                selectedValue: "\(manager.tempoItem.bpm)",
                didValueChange: action
            )
        }
        .popup(isPresented: isSubdivisionPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .clear) {
            let datas = ["♩", "♪", "♫", "♬", "♭", "♮", "♯", "𝄡"]
            let action: ((String, Bool) -> Void) = { newValue, complete in
                
            }
            PopupBottomPicker(
                isPresented: isSubdivisionPresented,
                title: "Subdivision",
                datas: datas,
                defaultValue: TempoItem.subdivision,
                selectedValue: manager.tempoItem.subDivision,
                didValueChange: action
            )
        }
        .popup(isPresented: isSoundEffectPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .clear) {
            let datas = ["Sound 1", "Sound 2", "Sound 3", "Sound 4"]
            let action: ((String, Bool) -> Void) = { newValue, complete in
                
            }
            PopupBottomPicker(
                isPresented: isSoundEffectPresented,
                title: "Sound Effect",
                datas: datas,
                defaultValue: TempoItem.soundEffect,
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
            .frame(width: 200, height: 200, alignment: .center)
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
        Button("\(manager.tempoItem.subDivision)") {
            isSubdivisionPresented = true
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private func soundButton() -> some View {
        Button("Sound") {
            isSoundEffectPresented = true
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private func nagivationLeftView() -> some View {
        NavigationLink(
            "Import",
            destination: TempoLibraryScreen(shouldAutoDismiss: true) { newTempo in
                manager.tempoItem = newTempo
            }
        )
        .foregroundColor(Theme.mainColor)
    }
    
    @ViewBuilder private func navigationRightView() -> some View {
        Button("Save to library") {
            manager.tempoItem.replace()
            isSaveSucessPresented = true
        }
        .foregroundColor(Theme.mainColor)
    }
}
