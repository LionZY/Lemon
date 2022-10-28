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
        ZStack {
            TunerView(
                tunerData: TunerData(pitch: pitchDetector.pitch),
                modifierPreference: modifierPreference,
                selectedTransposition: selectedTransposition
            )
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    startAudio()
                case .background:
                    stopAudio()
                default:
                    break
                }
            }
            .onDidAppear {
                startAudio()
            }
            .onDidDisappear {
                stopAudio()
            }
            .alert(isPresented: $pitchDetector.showMicrophoneAccessAlert) {
                MicrophoneAccessAlert()
            }
            ActivityIndicatorView(
                isVisible: $showLoadingIndicator,
                type: .scalingDots(count: 3, inset: 6)
            )
            .frame(width: 44.0, height: 44.0)
            .foregroundColor(Theme.redColor)
        }
    }
    
    private func startAudio() {
        pitchDetector.start()
    }
    
    private func stopAudio() {
        pitchDetector.stop()
    }
}

struct TunerScreen_Previews: PreviewProvider {
    static var previews: some View {
        TunerScreen()
    }
}
