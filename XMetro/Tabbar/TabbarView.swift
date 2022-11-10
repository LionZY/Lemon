//
//  TabView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture

enum PopType {
case timeSignature
case bpm
case sound
case duration
case saveSuccess
case reverted
case none
}

struct TabbarView: View {
    @ObservedObject var manager = TempoRunManager()
    
    @State private var isTimeSignaturePresented: Bool = false
    @State private var isBPMPresented: Bool = false
    @State private var isSoundEffectPresented: Bool = false
    @State private var isDurationPresented: Bool = false
    @State private var isSaveSucessPresented: Bool = false
    @State private var isRevertedToDefault: Bool = false
    
    let store: Store<TabState, TabAction> = Store(initialState: TabState(), reducer: tabReducer, environment: TabEnv())
    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                VStack(spacing: 0) {
                    viewStore.state.current.content(manager: manager)
                    HStack {
                        ForEach(viewStore.state.items, id: \.self) {
                            TabItemView(viewStore: viewStore, item: $0)
                        }
                    }
                    .background(Theme.whiteColor)
                }
                .pop(
                    self,
                    manager,
                    $isTimeSignaturePresented,
                    $isBPMPresented,
                    $isSoundEffectPresented,
                    $isDurationPresented,
                    $isSaveSucessPresented,
                    $isRevertedToDefault
                )
                .onAppear {
                    manager.tabbar = self
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    func pop(type: PopType, value: Bool) {
        switch type {
        case .timeSignature: isTimeSignaturePresented = value
        case .bpm: isBPMPresented = value
        case .sound: isSoundEffectPresented = value
        case .duration: isDurationPresented = value
        case .saveSuccess: isSaveSucessPresented = value
        case .reverted: isRevertedToDefault = value
        case .none: break
        }
    }
    
    func popStatus(type: PopType) -> Bool {
        switch type {
        case .timeSignature: return isTimeSignaturePresented;
        case .bpm:  return isBPMPresented;
        case .sound:  return isSoundEffectPresented;
        case .duration:  return isDurationPresented;
        case .saveSuccess:  return isSaveSucessPresented;
        case .reverted:  return isRevertedToDefault;
        case .none: return false
        }
    }
}

extension View {
    @ViewBuilder func pop(
        _ tabbar: TabbarView,
        _ manager: TempoRunManager,
        _ isTimeSignaturePresented: Binding<Bool>,
        _ isBPMPresented: Binding<Bool>,
        _ isSoundEffectPresented: Binding<Bool>,
        _ isDurationPresented: Binding<Bool>,
        _ isSaveSucessPresented: Binding<Bool>,
        _ isRevertedToDefault: Binding<Bool>
    ) -> some View {
        self.popup(isPresented: isTimeSignaturePresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: false, closeOnTapOutside: true, backgroundColor: .clear) {
            let action: ((String, Bool) -> Void) = { newValue, complete in
                let components = newValue.components(separatedBy: "/")
                let newMeter = Int(components.first ?? "4") ?? 4
                let newDevide = Int(components.last ?? "4") ?? 4
                manager.state.tempoItem.meter = newMeter
                manager.state.tempoItem.devide = newDevide
                if complete {
                    manager.tabbar?.pop(type: .timeSignature, value: false)
                    manager.notifyListeners()
                }
            }
            PopupTwoPickers(
                isPresented: isTimeSignaturePresented,
                title: "Time Signature",
                leftDatas: meterSet,
                rightDatas: devideSet,
                defaultValue: "\(manager.state.tempoItemBeforeEdit.meter)/\(manager.state.tempoItemBeforeEdit.devide)",
                selectedValue: "\(manager.state.tempoItem.meter)/\(manager.state.tempoItem.devide)",
                didValueChange: action
            )
        }
        .popup(isPresented: isBPMPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: false, closeOnTapOutside: true, backgroundColor: .clear) {
            let action: ((String, Bool) -> Void) = { newValue, complete in
                let newBPM = Int(newValue) ?? 60
                manager.state.tempoItem.bpm = newBPM
                if complete {
                    manager.tabbar?.pop(type: .bpm, value: false)
                    manager.notifyListeners()
                }
                if manager.isCountDownStoped { manager.run() }
            }
            PopupPicker(
                isPresented: isBPMPresented,
                title: "BPM",
                datas: bpmSet,
                defaultValue: "\(manager.state.tempoItemBeforeEdit.bpm)",
                selectedValue: "\(manager.state.tempoItem.bpm)",
                didValueChange: action
            )
        }
        .popup(isPresented: isSoundEffectPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: false, closeOnTapOutside: true, backgroundColor: .clear) {
            let action: ((String, Bool) -> Void) = { newValue, complete in
                manager.state.tempoItem.soundEffect = newValue
                PlayerManager.recreatePlayers(manager: manager)
                if complete {
                    manager.tabbar?.pop(type: .sound, value: false)
                    manager.notifyListeners()
                }
            }
            PopupPicker(
                isPresented: isSoundEffectPresented,
                title: "Sound effect",
                datas: soundSet,
                defaultValue: manager.state.tempoItemBeforeEdit.soundEffect,
                selectedValue: manager.state.tempoItem.soundEffect,
                didValueChange: action
            )
        }
        .popup(isPresented: isDurationPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: false, closeOnTapOutside: true, backgroundColor: .clear) {
            let action: ((String, Bool) -> Void) = { newValue, complete in
                manager.state.tempoItem.duration = newValue
                if complete {
                    manager.tabbar?.pop(type: .duration, value: false)
                    manager.notifyListeners()
                }
            }
            PopupPicker(
                isPresented: isDurationPresented,
                title: "Duration(Minutes)",
                datas: durationSet,
                defaultValue: manager.state.tempoItemBeforeEdit.duration,
                selectedValue: manager.state.tempoItem.duration,
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


struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
