//
//  Rooms.swift
//  Death Towards Life
//
//  Created by Skyler Hope on 1/5/23.
//

import Foundation

// rooms: GrindRoom/SpawnerRoom, ShopRoom, TreasureChestRoom, BossRoom, EncounterRoom



class Room {
    var fogOfWar: Bool = true
    
    func enterRoom() {
        fogOfWar = false
    }
    
//    func exitRoom() {
//        <#code#>
//    }
    
    
    
}

class FirstRoom: Room {
    //make fogwar false when instancing firstroom

}

class Shop: Room {
    let player: Player = GameManager.shared.currentPlayer
    
    var inventory: [Items] = []
    
    func playerSells(item: Items) {
        player.gold += item.goldValue
        item.remove()
        inventory.append(item)
        item.goldValue = Int(Double(item.goldValue) * 0.2)
    }
    
    func playerBuys(item: Items) {
        guard player.gold >= item.goldValue else {
            return print("Not enough gold to buy this.") }
        player.gold -= item.goldValue
        player.inventory.append(item)
        inventory.removeAll(where: { $0 == item })
    }
}

class TreasureRoom: Room {
    
}

class BossRoom: Room {
    
}

class EncounterRoom: Room {
    
}
