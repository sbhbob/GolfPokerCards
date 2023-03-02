//
//  LandingView.swift
//  Toward Life
//
//  Created by Skyler Hope on 1/15/23.
//

import Foundation
import SwiftUI

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-present-a-full-screen-modal-view-using-fullscreencover

enum Path {
    case newGame
    case map
}
struct LandingView: View {

    @State private var offset = CGSize.zero
    @State private var showButtons = false
//    @State var path: [Path] = []
    
    @State private var NGisPresented = false
    @State private var CisPresented = false

    var body: some View {
//        NavigationStack(path: $path) {
            Spacer()
            VStack {
                VStack {
                    Text("Toward Life")
                        .font(.largeTitle)
                    Text("By Skyler Hope")
                        .opacity(showButtons ? 0 : 1)
                    Text("Assisted by OpenAI's AI assistants")
                        .opacity(showButtons ? 0 : 1)
                }
                .offset(y: offset.height)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        self.showButtons = true
                    }
                }
                
//                NavigationLink(value: Path.newGame) {
//                    Text("New Game")
//                }
                Button("New Game") {
                    NGisPresented.toggle()
                }
                .fullScreenCover(isPresented: $NGisPresented, content: NewGameView.init)
                .opacity(showButtons ? 1 : 0)
                .padding()
                
//                NavigationLink(value: Path.map) {
//                    Button("Continue") {
//
//                    }
//                }
                Button("Continue") {
                    CisPresented.toggle()
                }
                .fullScreenCover(isPresented: $CisPresented, content: MapView.init)
                .opacity(showButtons ? 1 : 0)
            }
            Spacer()
//                .navigationDestination(for: Path.self) { path in
//                    switch path {
//                    case .newGame:
//                        NewGameView()
//                    case .map:
//                        MapView()
//                    }
//                }
//        }
    }

}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            LandingView()
                .previewDisplayName("Landing")
        }
    }
}
