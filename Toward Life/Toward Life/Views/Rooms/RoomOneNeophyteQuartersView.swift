//
//  RoomOneNeophyteQuartersView.swift
//  Toward Life
//
//  Created by Skyler Hope on 1/30/23.
//

import Foundation
import SwiftUI

struct RoomOneNeophyteQuartersView: View {
    @State private var aquiredItem: Items = BlankItem()
    @State private var chestIsEmpty = false
    @State private var corridorIsPresented = false
    let player = GameManager.shared.currentPlayer
    var body: some View {
        VStack{
            HUD()
            Text("Neophyte Quarters")
                .font(.largeTitle)
                .padding()
            Text("As lunar beams of luminescence spill forth from beyond the veil of silk obscuring the window, your slumbering peers dream of ascending the mystical mountain. A repository of material possessions reposes at the base of thy bed. It contains thy sole treasure.")
                .padding()
            HStack {
                Button("Open Chest") {
                    if chestIsEmpty == false {
                        let chest = Chest()
                        let item = chest.initializeRandomItem(itemType: .weapon)
                        player.inventory.append(item)
                        aquiredItem = item
                        chestIsEmpty.toggle()
                    }
                    else {
                        print("Chest is empty")
                    }
                }
                if chestIsEmpty == false {
                    
                } else {
                    Image(systemName: "checkmark")
                }
            }
            .padding()
            Text("\(aquiredItem.name) added to inventory.")
                .padding()
            Text("\(aquiredItem.description)")
                .padding()
            Button("Enter Corridor") {
                corridorIsPresented.toggle()
            }
            .fullScreenCover(isPresented: $corridorIsPresented, content: RoomTwoCorridorView.init)
        }
    }
}



struct RoomOneNeophyteQuartersView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            RoomOneNeophyteQuartersView()
                .previewDisplayName("Neophyte Quarters")
        }
    }
}
