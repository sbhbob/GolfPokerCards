//
//  MapView.swift
//  Toward Life
//
//  Created by Skyler Hope on 1/15/23.
//

import Foundation
import SwiftUI


//struct MapView: View {
//    var body: some View {
//        NavigationView {
//            VStack{
//                Text("mapmapmap")
//            }
//            .navigationTitle("Map")
//        }
//
//    }
//
//}

struct MapView: View {
    @State private var currentIndex = 0
    let squares = Array(0..<25)

    var body: some View {
        VStack {
            Spacer()
            HStack {
                if currentIndex > 0 {
                    Button(action: {
                            withAnimation(.spring()) {
                        self.currentIndex -= 1
                    }
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                } else {
                    Button(action: {}) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.gray)
                    }
                }

                SquareView(index: squares[currentIndex])

                if currentIndex < squares.count - 1 {
                    Button(action: {
                            withAnimation(.spring()) {
                        self.currentIndex += 1
                    }
                    }) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.black)
                    }
                } else {
                    Button(action: {}) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.gray)
                    }
                }
            }
            Button("Enter") {
                // if gamestate.fogofwar > currentindex {
                // currentIndexIsPresented.toggle() or sumptn
                // }
                // else background.gray
            }
            Spacer()
        }
        
    }
}

struct SquareView: View {
    let index: Int

    var body: some View {
        VStack {
            Spacer()

            Text("Square \(index + 1)")
                .font(.largeTitle)

            Spacer()
        }
        .frame(width: 200, height: 200)
        .background(Color.gray)
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            MapView()
                .previewDisplayName("Map")
        }
    }
}
