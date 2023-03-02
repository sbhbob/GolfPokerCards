//
//  Chest.swift
//  Toward Life
//
//  Created by Skyler Hope on 1/30/23.
//

import Foundation

enum commonItems {
    
}


class Chest {
    
    
    func initializeRandomItem(itemType: ItemType) -> Items {
        let items = [ShortSword(), LongSword(), GreatSword(), MithrilSword(), Excalibur(), Dagger(), Kris(), Stiletto(), Rapier(), Katana(), Claymore(), HealthPotion(), HealingHerb(), HealingRoot(), HealingFruit(), Elixir(), Bandage(), WoodenShield(), IronShield(), SteelShield(), MithrilShield(), MagicShield(), FireScroll(), IceScroll(), LightningScroll(), EarthScroll(), WindScroll(), WaterScroll(), PoisonScroll(), LifeScroll(), DeathScroll()]
        
        var rarity: Rarity = .common
        
        if GameManager.shared.currentPlayer.level < 5 {
                rarity = .common
            } else if GameManager.shared.currentPlayer.level >= 5 && GameManager.shared.currentPlayer.level < 10 {
                rarity = .uncommon
            } else if GameManager.shared.currentPlayer.level >= 10 && GameManager.shared.currentPlayer.level < 15 {
                rarity = .rare
            } else if GameManager.shared.currentPlayer.level >= 15 {
                rarity = .legendary
            }
        
        let filteredItems = items.filter { $0.type == itemType && $0.rarity == rarity }
        let randomIndex = Int.random(in: 0..<filteredItems.count)
        return filteredItems[randomIndex]
    }
}

