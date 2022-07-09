//
//  BoredButtonView.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture
import AudioToolbox

struct BoredButtonView: View {
    
    let store: Store<BoredButtonState, BoredButtonAction>
    var dotWidth = 10.0
    var dotSpace = 10.0
    
    @State private var presentedCount = false
    @State private var presentedBmp = false
    
    func backgroundColor(_ viewStore: ViewStore<BoredButtonState, BoredButtonAction>) -> Color {
        switch viewStore.state.currentAction {
        case .run:
            return viewStore.state.isCountDown ? Color(.systemYellow) :.red
        case .stop:
            return .black
        default:
            return .black
        }
    }

    func dotColor(_ viewStore: ViewStore<BoredButtonState, BoredButtonAction>, dotIndex: Int) -> Color {
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
                    Button(viewStore.state.title) {
                        if viewStore.state.currentAction == .stop {
                            viewStore.send(.run)
                        } else {
                            viewStore.send(.stop)
                        }
                    }
                    .frame(width: 200, height: 200, alignment: .center)
                    .background(backgroundColor(viewStore))
                    .foregroundColor(.white)
                    .font(viewStore.state.isCountDown ? .system(size: 68.0) : .system(size: 40.0))
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
                                    defaultIndex: viewStore.state.count
                                ) { selected in
                                    viewStore.send(.updateCount(selected))
                                }
                            }
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
                                    defaultIndex: viewStore.state.bpm
                                ) { selected in
                                    viewStore.send(.updateBpm(selected))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct BoredButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BoredButtonView(store: Store(initialState: BoredButtonState(), reducer: BoredButtonReducer, environment: BoredButtonEnv()))
    }
}
