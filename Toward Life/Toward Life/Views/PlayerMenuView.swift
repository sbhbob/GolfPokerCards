//
//  PlayerMenuView.swift
//  Toward Life
//
//  Created by Skyler Hope on 1/15/23.
//

import Foundation
import SwiftUI

struct PlayerMenuView: View {
    let player = GameManager.shared.currentPlayer
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Inventory")
                    .font(.headline)
                ForEach(player.inventory) { item in
                    Text("\(item.name)")
                }
                .padding()
                Text("Magick")
                    .font(.headline)
            }
            .navigationTitle("Satchel")
            .toolbar {
                Button("Back") {
                    dismiss()
                }
            }
        }
    }
}


struct PlayerMenuView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            PlayerMenuView()
                .previewDisplayName("Player Menu")
        }
    }
}
