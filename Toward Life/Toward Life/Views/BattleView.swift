//
//  BattleView.swift
//  Toward Life
//
//  Created by Skyler Hope on 1/31/23.
//

import Foundation
import SwiftUI


struct BattleView: View {
    @State private var selectItemIsPresented = false
    
    let player = GameManager.shared.currentPlayer
    let enemy: Enemy
    
    @State private var selectedOption = false
    @State var playerTurn = false
    
    var body: some View {
        
        VStack {
            HUD() // make the opponent higher
                .padding()
            Text("Enemy: \(enemy.name)")
            Text("Enemy HP: \(enemy.currentHP)/\(enemy.maxHP)")
            
            // if enemy and player health over zoero, unless game over or you won
            
            if playerTurn == false {
                Text("\(enemy.name) attacks.")
                Button("OK") {
                    player.currentHP -= enemy.atk
                    playerTurn.toggle()
                }
            }
            
            else if playerTurn == true {
                HStack {
                    Button(action: {
                        enemy.currentHP -= player.atk
                        // selectedOption = true
                        playerTurn.toggle()
                    }) {
                        Text("Melee Attack")
                    }
                    
                    Button(action: {
                        selectItemIsPresented.toggle()
                        playerTurn.toggle()
                    }) {
                        Text("Use Item")
                    }
                    .fullScreenCover(isPresented: $selectItemIsPresented, content: SelectItemView.init)
                    
                    Button(action: {
                        playerTurn.toggle()
                        
                    }) {
                        Text("Use Magick")
                    }
                }
            }
        }
    }
}

// Needs describers, maybe alerts?
//
//
//
//

struct SelectItemView: View {
    @Environment(\.dismiss) var dismiss
    let player = GameManager.shared.currentPlayer
    let inventory = GameManager.shared.currentPlayer.inventory
    var body: some View {
        VStack {
            Text("Inventory")
            if inventory == [] {
                Button("No items to use") {
                    dismiss()
                }
            } else {
                ForEach(inventory) { item in
                    Button("\(item.name)") {
                        item.use()
                        dismiss()
                    }
                }
            }
        }
    }
}


struct BattleView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            BattleView(enemy: Skeleton())
                .previewDisplayName("Landing")
        }
    }
}
