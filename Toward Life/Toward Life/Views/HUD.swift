//
//  HUD.swift
//  Toward Life
//
//  Created by Skyler Hope on 1/31/23.
//

import Foundation
import SwiftUI

struct HUD: View {
    let player = GameManager.shared.currentPlayer
    @State private var menuIsPresented = false
    
    var body: some View {
        HStack {
            Button(action: {
                menuIsPresented.toggle()
            }) {
                Image(systemName: "book")
                    .imageScale(.large)
            }
            .fullScreenCover(isPresented: $menuIsPresented, content: PlayerMenuView.init)

            VStack{
                Text("\(player.name)")
                
                HStack {
                    Text("HP: \(player.currentHP)")
                    Text("ATK: \(player.atk)")
                    Text("LVL: \(player.level)")
                    Text("EXP: \(player.experience)")
                }
            }
        }
    }
}


struct HUD_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            HUD()
        }
    }
}
