//
//  MetroActionButton.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture
import AudioToolbox

struct MetroActionButton: View {
    
    let store: Store<MetroActionButtonState, MetroActionButtonAction>
    var dotWidth: Double
    var dotSpace: Double
    
    @State private var timeSignatureButtonTitle: String
    @State private var presentedTimeSignature: Bool
    @State private var presentedBmp: Bool
    
    init(
        store: Store<MetroActionButtonState, MetroActionButtonAction>,
        dotWidth: Double = 10.0,
        dotSpace: Double = 10.0,
        timeSignatureButtonTitle: String = "",
        presentedTimeSignature: Bool = false,
        presentedBmp: Bool = false
    ) {
        self.store = store
        self.dotWidth = dotWidth
        self.dotSpace = dotSpace
        self.timeSignatureButtonTitle = timeSignatureButtonTitle
        self.presentedTimeSignature = presentedTimeSignature
        self.presentedBmp = presentedBmp
    }
    
    func backgroundColor(_ viewStore: ViewStore<MetroActionButtonState, MetroActionButtonAction>) -> Color {
        switch viewStore.state.currentAction {
        case .run:
            return viewStore.state.isCountDown ? Theme.middleLightColor : Theme.lightColor
        case .stop:
            return Theme.mainColor
        default:
            return Theme.mainColor
        }
    }

    func dotColor(_ viewStore: ViewStore<MetroActionButtonState, MetroActionButtonAction>, dotIndex: Int) -> Color {
        if dotIndex < viewStore.state.tempoItem.meter {
            return viewStore.state.currentIndex == dotIndex ? Theme.lightColor : Theme.mainColor
        }
        return Color(.systemGray5)
    }

    @ViewBuilder private func timeSignatureButton(viewStore: ViewStore<MetroActionButtonState, MetroActionButtonAction>) -> some View {
        Button(timeSignatureButtonTitle) {
            presentedTimeSignature = true
            viewStore.send(.stop)
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $presentedTimeSignature) {
            NavigationView {
                PickerView(
                    title: "Time Signature",
                    subject1Range:1..<13,
                    subject1: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                    subject1DefaultValue: viewStore.state.tempoItem.meter,
                    subject2: [1, 2, 3, 4, 5, 6, 7, 8],
                    subject2DefaultValue: viewStore.state.tempoItem.devide
                ) { selected1, selected2 in
                    viewStore.send(.updateTimeSignature(selected1, selected2))
                    timeSignatureButtonTitle = "\(TempoItem.savedMeter)/\(TempoItem.savedDevide)"
                }
            }.navigationViewStyle(.stack)
        }
    }
    
    @ViewBuilder private func bpmButton(viewStore: ViewStore<MetroActionButtonState, MetroActionButtonAction>) -> some View {
        Button("\(viewStore.state.tempoItem.bpm)") {
            presentedBmp = true
            viewStore.send(.stop)
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $presentedBmp) {
            NavigationView {
                PickerView(
                    title: "BPM",
                    subject1Range: 30..<300,
                    subject1: [40, 50, 60, 80, 120, 160, 200, 240],
                    subject1DefaultValue: viewStore.state.tempoItem.bpm,
                    subject2DefaultValue: 4
                ) { selected, _ in
                    viewStore.send(.updateBpm(selected))
                }
            }
            .navigationViewStyle(.stack)
        }
    }
    
    /*
    @ViewBuilder private func subDivisionButton(viewStore: ViewStore<MetroActionButtonState, MetroActionButtonAction>) -> some View {
        Button("♫") { }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private func accentsButton(viewStore: ViewStore<MetroActionButtonState, MetroActionButtonAction>) -> some View {
        Button("■□□□") { }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    */
    
    @ViewBuilder private func dotsView(viewStore: ViewStore<MetroActionButtonState, MetroActionButtonAction>) -> some View {
        VStack {
            ForEach(0..<3, id: \.self) { row in
                HStack {
                    ForEach(0..<4, id: \.self) { colum in
                        Text("")
                            .frame(width: dotWidth, height: dotWidth, alignment: .center)
                            .background(dotColor(viewStore, dotIndex: Int(row * 4 + colum)))
                            .foregroundColor(Theme.whiteColor)
                            .cornerRadius(dotWidth/2.0)
                    }
                }
            }
        }
        .onReceive(timer) { input in
            viewStore.send(.run)
        }.onAppear {
            viewStore.send(.updateBpm(TempoItem.savedBPM))
            viewStore.send(.updateTimeSignature(TempoItem.savedMeter, TempoItem.savedDevide))
            viewStore.send(.stop)
        }
    }
    
    @ViewBuilder private func actionButton(viewStore: ViewStore<MetroActionButtonState, MetroActionButtonAction>) -> some View {
        ImageButton(viewStore: viewStore)
            .onTapGesture {
                switch viewStore.state.currentAction {
                case .run: viewStore.send(.stop)
                case .stop: viewStore.send(.run)
                default: break
                }
            }
            .frame(width: 200, height: 200, alignment: .center)
            .font(.custom("Futura", size: viewStore.state.isCountDown ? 68 : 40))
            .background(backgroundColor(viewStore))
            .foregroundColor(Theme.whiteColor)
            .cornerRadius(100)
            .shadow(color: Theme.shadowColor, radius: 28.0, x: 0, y: 0)
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Spacer()
                actionButton(viewStore: viewStore)
                Spacer()
                dotsView(viewStore: viewStore)
                Spacer()
                HStack {
                    Spacer()
                    timeSignatureButton(viewStore: viewStore)
                    Spacer().frame(maxWidth: 10.0)
                    bpmButton(viewStore: viewStore)
                    /*
                    Spacer().frame(maxWidth: 10.0)
                    subDivisionButton(viewStore: viewStore)
                    Spacer().frame(maxWidth: 10.0)
                    accentsButton(viewStore: viewStore)
                    */
                    Spacer()
                }
                Spacer()
            }.onAppear {
                timeSignatureButtonTitle = "\(TempoItem.savedMeter)/\(TempoItem.savedDevide)"
            }
        }
    }
}

struct MetroActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MetroActionButton(store: Store(initialState: MetroActionButtonState(), reducer: MetroActionButtonReducer, environment: MetroActionButtonEnv()))
    }
}
