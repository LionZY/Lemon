import MicrophonePitchDetector
import SwiftUI
import ActivityIndicatorView

struct TunerScreen: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var pitchDetector = MicrophonePitchDetector()
    @State private var showLoadingIndicator = false
    @AppStorage("modifierPreference") private var modifierPreference = ModifierPreference.preferSharps
    @AppStorage("selectedTransposition") private var selectedTransposition = 0
    
    var body: some View {
        TunerView(
            tunerData: TunerData(pitch: pitchDetector.pitch),
            modifierPreference: modifierPreference,
            selectedTransposition: selectedTransposition
        )
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                startAudio()
            case .inactive, .background:
                stopAudio()
            @unknown default:
                stopAudio()
            }
        }
        .onAppear(perform: {
            startAudio()
            UIApplication.shared.isIdleTimerDisabled = true
        })
        .onDisappear(perform: {
            stopAudio()
        })
        .alert(isPresented: $pitchDetector.showMicrophoneAccessAlert) {
            MicrophoneAccessAlert()
        }
        ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .scalingDots(count: 3, inset: 6))
            .frame(width: 44.0, height: 44.0)
             .foregroundColor(.red)
    }
    
    private func startAudio() {
        showLoadingIndicator = true
        DispatchQueue.main.async {
            pitchDetector.start()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: DispatchWorkItem(block: {
                showLoadingIndicator = false
            }))
        }
    }
    
    private func stopAudio() {
        showLoadingIndicator = true
        DispatchQueue.main.async {
            pitchDetector.stop()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: DispatchWorkItem(block: {
                showLoadingIndicator = false
            }))
        }
    }
}

struct TunerScreen_Previews: PreviewProvider {
    static var previews: some View {
        TunerScreen()
    }
}
