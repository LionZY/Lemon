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
    var dotWidth = 10.0
    var dotSpace = 10.0
    
    @State private var presentedCount = false
    @State private var presentedBmp = false
    
    func backgroundColor(_ viewStore: ViewStore<MetroActionButtonState, MetroActionButtonAction>) -> Color {
        switch viewStore.state.currentAction {
        case .run:
            return viewStore.state.isCountDown ? .yellow : .red
        case .stop:
            return .black
        default:
            return .black
        }
    }

    func dotColor(_ viewStore: ViewStore<MetroActionButtonState, MetroActionButtonAction>, dotIndex: Int) -> Color {
        if dotIndex < viewStore.state.count {
             return viewStore.state.currentIndex == dotIndex ? .red : .black
        }
        return Color(.systemGray5)
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                VStack {
                    Spacer()
                    // 中间大按钮
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
                        .foregroundColor(.white)
                        .cornerRadius(100)
                        .shadow(color: .gray, radius: 28.0, x: 0, y: 0)
                    Spacer()
                    
                    // 波点
                    VStack {
                        ForEach(0..<3, id: \.self) { row in
                            HStack {
                                ForEach(0..<4, id: \.self) { colum in
                                    Text("")
                                        .frame(width: dotWidth, height: dotWidth, alignment: .center)
                                        .background(dotColor(viewStore, dotIndex: Int(row * 4 + colum)))
                                        .foregroundColor(.white)
                                        .cornerRadius(dotWidth/2.0)
                                }
                            }
                        }
                    }
                    .onReceive(timer) { input in
                        viewStore.send(.run)
                    }.onAppear {
                        var savedBPM = UserDefaults.standard.integer(forKey: KSaved_BPM)
                        savedBPM = savedBPM == 0 ? 60 : savedBPM
                        viewStore.send(.updateBpm(savedBPM))
                        var savedMeter = UserDefaults.standard.integer(forKey: KSaved_Meter)
                        savedMeter = savedMeter == 0 ? 4 : savedMeter
                        viewStore.send(.updateCount(savedMeter))
                        viewStore.send(.stop)
                    }
                    
                    Spacer()
                    
                    // 参数调节按钮
                    HStack {
                        Button("Meter: \(viewStore.state.count)") {
                            presentedCount = true
                            viewStore.send(.stop)
                        }
                        .tint(.black)
                        .controlSize(.regular)
                        .buttonStyle(.borderedProminent)
                        .sheet(isPresented: $presentedCount) {
                            NavigationView {
                                PickerView(
                                    title: "Meter",
                                    datas:1..<13,
                                    presets: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                                    defaultValue: viewStore.state.count
                                ) { selected in
                                    viewStore.send(.updateCount(selected))
                                }
                            }.navigationViewStyle(.stack)
                        }
                        Spacer().frame(maxWidth: 20.0)
                        Button("BPM: \(viewStore.state.bpm)") {
                            presentedBmp = true
                            viewStore.send(.stop)
                        }
                        .tint(.black)
                        .controlSize(.regular)
                        .buttonStyle(.borderedProminent)
                        .sheet(isPresented: $presentedBmp) {
                            NavigationView {
                                PickerView(
                                    title: "BPM",
                                    datas: 30..<300,
                                    presets: [40, 50, 60, 80, 120, 160, 200, 240],
                                    defaultValue: viewStore.state.bpm
                                ) { selected in
                                    viewStore.send(.updateBpm(selected))
                                }
                            }
                            .navigationViewStyle(.stack)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct MetroActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MetroActionButton(store: Store(initialState: MetroActionButtonState(), reducer: MetroActionButtonReducer, environment: MetroActionButtonEnv()))
    }
}
