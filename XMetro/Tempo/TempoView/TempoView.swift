//
//  TempoView.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture
import AudioToolbox

struct TempoView: View {
    
    let store: Store<TempoViewState, TempoViewAction>
    var dotWidth: Double
    var dotSpace: Double
    
    init(
        store: Store<TempoViewState, TempoViewAction>,
        dotWidth: Double = 10.0,
        dotSpace: Double = 10.0
    ) {
        self.store = store
        self.dotWidth = dotWidth
        self.dotSpace = dotSpace
    }
    
    func backgroundColor(_ viewStore: ViewStore<TempoViewState, TempoViewAction>) -> Color {
        switch viewStore.state.currentAction {
        case .run:
            return viewStore.state.isCountDown ? Theme.middleLightColor : Theme.lightColor
        case .stop:
            return Theme.mainColor
        default:
            return Theme.mainColor
        }
    }

    func dotColor(_ viewStore: ViewStore<TempoViewState, TempoViewAction>, dotIndex: Int) -> Color {
        if dotIndex < viewStore.state.tempoItem.meter {
            return viewStore.state.currentIndex == dotIndex ? Theme.lightColor : Theme.mainColor
        }
        return Color(.systemGray5)
    }

    @ViewBuilder private func meterButton(viewStore: ViewStore<TempoViewState, TempoViewAction>) -> some View {
        let meter = String(TempoItem.savedMeter)
        let datas = Array(1..<13).map { String($0) }
        let devide = TempoItem.savedDevide
        PickerButton(selectedValue: meter, datas: datas) { newValue in
            let newMeter = Int(newValue) ?? 4
            viewStore.send(.updateTimeSignature(newMeter, devide))
        }
        .onTapGesture {
            viewStore.send(.stop)
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private func devideButton(viewStore: ViewStore<TempoViewState, TempoViewAction>) -> some View {
        let devide = String(TempoItem.savedDevide)
        let datas = Array(1..<9).map { String($0) }
        let meter = TempoItem.savedMeter
        PickerButton(selectedValue: devide, datas: datas) { newValue in
            let newDevide = Int(newValue) ?? 4
            viewStore.send(.updateTimeSignature(meter, newDevide))
        }
        .onTapGesture {
            viewStore.send(.stop)
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private func bpmButton(viewStore: ViewStore<TempoViewState, TempoViewAction>) -> some View {
        let bpm = String(TempoItem.savedBPM)
        let datas = Array(stride(from: 30, to: 305, by: 5)).map { String($0) }
        PickerButton(selectedValue: bpm, datas: datas) { newValue in
            viewStore.send(.updateBpm(Int(newValue) ?? 60))
        }
        .onTapGesture {
            viewStore.send(.stop)
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private func subDivisionButton(viewStore: ViewStore<TempoViewState, TempoViewAction>) -> some View {
        let subDivision = TempoItem.savedSubdivision
        let datas = ["♪", "♩", "♫", "♬", "¶", "‖♭", "♯", "§", "∮"]
        PickerButton(selectedValue: subDivision, datas: datas) { newSubdivision in
            viewStore.send(.updateSubdivision(newSubdivision))
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private func accentsButton(viewStore: ViewStore<TempoViewState, TempoViewAction>) -> some View {
        Button("■□□□") {
            
        }
        .tint(Theme.mainColor)
        .controlSize(.regular)
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private func dotsView(viewStore: ViewStore<TempoViewState, TempoViewAction>) -> some View {
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
    
    @ViewBuilder private func actionButton(viewStore: ViewStore<TempoViewState, TempoViewAction>) -> some View {
        TempoViewActionButton(viewStore: viewStore)
            .frame(width: 200, height: 200, alignment: .center)
            .font(.custom("Futura", size: viewStore.state.isCountDown ? 68 : 40))
            .background(backgroundColor(viewStore))
            .foregroundColor(Theme.whiteColor)
            .shadow(color: Theme.shadowColor, radius: 28.0, x: 0, y: 0)
            .cornerRadius(100)
            .onTapGesture {
                switch viewStore.state.currentAction {
                case .run: viewStore.send(.stop)
                case .stop: viewStore.send(.run)
                default: break
                }
            }
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
                    HStack {
                        meterButton(viewStore: viewStore)
                        Text("/")
                        devideButton(viewStore: viewStore)
                    }
                    Spacer().frame(maxWidth: 10.0)
                    bpmButton(viewStore: viewStore)
                    Spacer().frame(maxWidth: 10.0)
                    subDivisionButton(viewStore: viewStore)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct TempoView_Previews: PreviewProvider {
    static var previews: some View {
        TempoView(store: Store(initialState: TempoViewState(), reducer: TempoViewReducer, environment: TempoViewEnv()))
    }
}
