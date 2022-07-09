//
//  BoardButtonView.swift
//  WhenBored
//
//  Created by Yue Zhang on 2022/7/7.
//

import SwiftUI
import ComposableArchitecture
import AudioToolbox

struct BoardButtonView: View {
    
    let store: Store<BoardButtonState, BoardButtonAction>
    var dotWidth = 20.0
    var dotSpace = 20.0
    
    func backgroundColor(_ viewStore: ViewStore<BoardButtonState, BoardButtonAction>) -> Color {
        switch viewStore.state.currentAction {
        case .run:
            return viewStore.state.isCountDown ? .gray :.red
        case .stop:
            return .black
        }
    }
    
    func currentDotColor(_ viewStore: ViewStore<BoardButtonState, BoardButtonAction>, dotIndex: Int) -> Color {
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
                        ForEach(0..<4, id: \.self) { dotIdxStr in
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
                        Button("Count: \(viewStore.state.count)") { }
                        .tint(.black)
                        .controlSize(.regular)
                        .buttonStyle(.borderedProminent)
                        Spacer().frame(maxWidth: 30.0)
                        Button("BPM: \(viewStore.state.bpm)") { }
                        .tint(.black)
                        .controlSize(.regular)
                        .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct BoardButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BoardButtonView(store: Store(initialState: BoardButtonState(), reducer: boardButtonReducer, environment: BoardButtonEnv()))
    }
}
