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
    // MARK: - Status -
    private var isCountDown: Bool { countDownIndex < 0 && countDownIndex > -4 }
    private var isReadyCountDown: Bool { countDownIndex == -4 }
    private var isCountDownStoped: Bool { countDownIndex == 0 }
    private var isRunning: Bool { countDownIndex > -4 }
    private var action: TempoScreenAction { isReadyCountDown ? .run : .stop }
    private var timerEvery: CGFloat { countDownIndex == -4 ? 1.0 : (60.0 / CGFloat(bpm)) }
    private var shouldPlayStrong: Bool { runingIndex == 0 }
    
    // MARK: - Timer -
    private var timer: TGCDTimer?
    private var countDownTimer: TGCDTimer?
    
    // MARK: - Index -
    @State private var runingIndex: Int = -1
    @State private var countDownIndex: Int = -4

    // MARK: - data -
    @State private var meter: Int = TempoItem.meter
    @State private var devide: Int = TempoItem.devide
    @State private var bpm: Int = TempoItem.bpm
    @State private var subdivision: String = TempoItem.subdivision
    @State private var soundEffect: String = TempoItem.soundEffect

    // MARK: - Popups -
    @State private var isTimeSignaturePresented: Bool = false
    @State private var isBPMPresented: Bool = false
    @State private var isSubdivisionPresented: Bool = false
    @State private var isSoundEffectPresented: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            actionButton()
            Spacer()
            dotsView()
            Spacer()
            HStack(spacing: 10.0) {
                Spacer()
                meterButton()
                bpmButton()
                subDivisionButton()
                soundButton()
                Spacer()
            }
            Spacer()
        }
        .navigationTitle("Tempo")
        .popup(isPresented: $isTimeSignaturePresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: false, closeOnTapOutside: false, backgroundColor: .clear) {
            let action: ((String, Bool) -> Void) = { newValue, complete in
                let components = newValue.components(separatedBy: "/")
                meter = Int(components.first ?? "4") ?? 4
                devide = Int(components.last ?? "4") ?? 4
                if complete {
                    TempoItem.save(meter, forKey: TempoItem.KSaved_Meter)
                    TempoItem.save(devide, forKey: TempoItem.KSaved_Devide)
                }
            }
            PopupBottomPicker(
                isPresented: $isTimeSignaturePresented,
                title: "Time Signature",
                datas: meterSet,
                defaultValue: "\(TempoItem.meter)/\(TempoItem.devide)",
                selectedValue: "\(meter)/\(devide)",
                didValueChange: action
            )
        }
        .popup(isPresented: $isBPMPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: false, closeOnTapOutside: false, backgroundColor: .clear) {
            let defaultValue = "\(bpm)"
            let action: ((String, Bool) -> Void) = { newValue, complete in
                bpm = Int(newValue) ?? 60
                if complete { TempoItem.save(bpm, forKey: TempoItem.KSaved_BPM) }
                if isCountDownStoped { run() }
            }
            PopupBottomPicker(
                isPresented: $isBPMPresented,
                title: "BPM",
                datas: bpmSet,
                defaultValue: "\(TempoItem.bpm)",
                selectedValue: "\(bpm)",
                didValueChange: action
            )
        }
        .popup(isPresented: $isSubdivisionPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: false, closeOnTapOutside: false, backgroundColor: .clear) {
            let datas = ["♩", "♪", "♫", "♬", "♭", "♮", "♯", "𝄡"]
            let action: ((String, Bool) -> Void) = { newValue, complete in
                
            }
            PopupBottomPicker(
                isPresented: $isSubdivisionPresented,
                title: "Subdivision",
                datas: datas,
                defaultValue: TempoItem.subdivision,
                selectedValue: subdivision,
                didValueChange: action
            )
        }
        .popup(isPresented: $isSoundEffectPresented, type: .floater(), position: .bottom, dragToDismiss: false, closeOnTap: false, closeOnTapOutside: false, backgroundColor: .clear) {
            let datas = ["Sound 1", "Sound 2", "Sound 3", "Sound 4"]
            let action: ((String, Bool) -> Void) = { newValue, complete in
                
            }
            PopupBottomPicker(
                isPresented: $isSoundEffectPresented,
                title: "Sound Effect",
                datas: datas,
                defaultValue: TempoItem.soundEffect,
                selectedValue: soundEffect,
                didValueChange: action
            )
        }
        .onDisappear {
            stop()
        }
    }
    
    // MARK: - View builders -
    @ViewBuilder private func actionButton() -> some View {
        TempoRunButton(countDownIndex: $countDownIndex)
            .frame(width: 200, height: 200, alignment: .center)
            .font(.custom("Futura", size: isCountDown ? 68 : 40))
            .cornerRadius(100)
            .shadow(color: Theme.shadowColor, radius: 28.0, x: 0, y: 0)
            .onTapGesture {
                send(action)
            }
    }

    @ViewBuilder private func dotsView() -> some View {
        TempoDotsView(countDownIndex: $countDownIndex, runningIndex: $runingIndex, total: $meter)
    }
    
    @ViewBuilder private func meterButton() -> some View {
        Button("\(meter)/\(devide)") {
            isTimeSignaturePresented = true
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }

    @ViewBuilder private func bpmButton() -> some View {
        Button("\(bpm)") {
            isBPMPresented = true
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private func subDivisionButton() -> some View {
        Button("\(subdivision)") {
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
    
    // MARK: - Actions -
    func coundDown() {
        if isReadyCountDown {
            XTimer.shared.createNewTimer(timerEvery: timerEvery) {
                if countDownIndex < 0 { countDownIndex = countDownIndex + 1 }
                if isCountDownStoped {
                    run()
                }
            }
        }
    }
    
    func stop() {
        XTimer.shared.cancelTimer()
        stopPlayers()
        countDownIndex = -4
        runingIndex = -1
    }
    
    func run() {
        XTimer.shared.cancelTimer()
        createPlayers()
        strongPlayer?.play()
        runingIndex = (runingIndex + 1) % meter
        XTimer.shared.createNewTimer(timerEvery: timerEvery) {
            runingIndex = (runingIndex + 1) % meter
            if shouldPlayStrong {
                strongPlayer?.play()
            } else {
                lightPlayer?.play()
            }
        }
    }
    
    func rerun() {
        XTimer.shared.cancelTimer()
    }
    
    func send(_ action: TempoScreenAction) {
        switch action {
        case .run:
            coundDown()
            break
        case .stop:
            stop()
            break
        }
    }
}

struct TempoScreen_Previews: PreviewProvider {
    static var previews: some View {
        TempoScreen()
    }
}
