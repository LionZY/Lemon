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
    var dotWidth = 20.0
    var dotSpace = 20.0
    
    @State private var presentedCount = false
    @State private var presentedBmp = false
    
    func backgroundColor(_ viewStore: ViewStore<BoredButtonState, BoredButtonAction>) -> Color {
        switch viewStore.state.currentAction {
        case .run:
            return viewStore.state.isCountDown ? .gray :.red
        case .stop:
            return .black
        default:
            return .black
        }
    }
    
    func currentDotColor(_ viewStore: ViewStore<BoredButtonState, BoredButtonAction>, dotIndex: Int) -> Color {
        viewStore.state.currentIndex == dotIndex ? .red : .black
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                VStack {
                    Spacer()
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
                    .font(viewStore.state.isCountDown ? .system(size: 60.0) : .system(.largeTitle))
                    .cornerRadius(100)
                    .shadow(color: .gray, radius: 28.0, x: 0, y: 0)
                    Spacer()
                    HStack {
                        Spacer()
                        ForEach(0..<viewStore.state.count, id: \.self) { dotIdxStr in
                            Text("")
                            .frame(width: dotWidth, height: dotWidth, alignment: .center)
                            .background(currentDotColor(viewStore, dotIndex: Int(dotIdxStr)))
                            .cornerRadius(dotWidth/2.0)
                            Spacer()
                        }.onReceive(timer) { input in
                            viewStore.send(.run)
                        }.onAppear {
                            viewStore.send(.stop)
                        }
                    }
                    Spacer().frame(maxHeight: 30.0)
                    HStack {
                        Button("Count: \(viewStore.state.count)") {
                            presentedCount = true
                        }
                        .tint(.black)
                        .controlSize(.regular)
                        .buttonStyle(.borderedProminent)
                        .sheet(isPresented: $presentedCount) {
                            NavigationView {
                                PickerView(title: "Select a count", datas: 0..<300, defaultIndex: viewStore.state.count) { selected in
                                    viewStore.send(.updateCount(selected))
                                }
                            }
                        }
                        Spacer().frame(maxWidth: 30.0)
                        Button("BPM: \(viewStore.state.bpm)") {
                            presentedBmp = true
                        }
                        .tint(.black)
                        .controlSize(.regular)
                        .buttonStyle(.borderedProminent)
                        .sheet(isPresented: $presentedBmp) {
                            NavigationView {
                                PickerView(title: "Select a bpm", datas: 0..<300, defaultIndex: viewStore.state.bpm) { selected in
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
