//
//  Items.swift
//  Death Towards Life
//
//  Created by Skyler Hope on 12/29/22.
//

import Foundation

enum ItemType {
    case weapon
    case magic
    case healing
    case defensive
}

enum Rarity: String {
    case common
    case uncommon
    case rare
    case legendary
}

// Base item class with name, rarity, gold value, and description properties
class Items: Equatable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var rarity: Rarity
    var goldValue: Int
    var description: String
    let type: ItemType
    let player: Player = GameManager.shared.currentPlayer
    let enemy: Enemy = BattleManager.shared.enemy

    init(name: String, type: ItemType, rarity: Rarity, goldValue: Int, description: String) {
        self.name = name
        self.type = type
        self.rarity = rarity
        self.goldValue = goldValue
        self.description = description
    }
    
    func remove() {
        guard let index = player.inventory.firstIndex(where: { $0.name == name }) else { return }
        player.inventory.remove(at: index)
    }
    
    func use() {
        
    }

  
    
    static func == (lhs: Items, rhs: Items) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(name)
    }
}

class BlankItem: Items {
    init() {
        super.init(name: "", type: .weapon, rarity: .common, goldValue: 0, description: "")
    }
}

// Subclass of Item for weapon items with a damageDealt property
class WeaponItem: Items {
    var damageDealt: Int

    init(name: String, rarity: Rarity, goldValue: Int, description: String, damageDealt: Int) {
        self.damageDealt = damageDealt
        super.init(name: name, type: .weapon, rarity: rarity, goldValue: goldValue, description: description)
    }
    func equip() {
        player.equippedWeapon = self
    }
    override func use() {
        print("Can't use that!")
    }
}

// Subclass of Item for healing items with an amountHealed property
class HealingItem: Items {
    var amountHealed: Int

    init(name: String, rarity: Rarity, goldValue: Int, description: String, amountHealed: Int) {
        self.amountHealed = amountHealed
        super.init(name: name, type: .healing, rarity: rarity, goldValue: goldValue, description: description)
    }
    
    override func use() {
        if player.currentHP > player.maxHP {
            print("Already at full health.")
        } else {
            player.currentHP += amountHealed
            remove()
            if player.currentHP > player.maxHP {
                player.currentHP = player.maxHP
            }
        }
        remove()
    }
}

// Subclass of Item for defensive items with a damageAbsorbed property
class DefensiveItem: Items {
    var damageAbsorbed: Int

    init(name: String, rarity: Rarity, goldValue: Int, description: String, damageAbsorbed: Int) {
        self.damageAbsorbed = damageAbsorbed
        super.init(name: name, type: .defensive, rarity: rarity, goldValue: goldValue, description: description)
    }
    
    override func use() {
        print("Can't use that!")
    }
}

// Subclass of Item for magic items with a damageDealt and duration properties
class MagicItem: Items {
    var damageDealt: Int
    var lootChance: Double

    init(name: String, rarity: Rarity, goldValue: Int, description: String, damageDealt: Int, lootChance: Double) {
        self.damageDealt = damageDealt
        self.lootChance = lootChance
        super.init(name: name, type: .magic, rarity: rarity, goldValue: goldValue, description: description)
    }
    
    override func use() {
        enemy.currentHP -= damageDealt * player.level
        remove()
    }
}

class ShortSword: WeaponItem {
    init() {
        super.init(name: "Short Sword",
                   rarity: .common,
                   goldValue: 10,
                   description: "A basic sword with a short, sharp blade.",
                   damageDealt: 5)
    }
}

class LongSword: WeaponItem {
    init() {
        super.init(name: "Long Sword",
                   rarity: .common,
                   goldValue: 15,
                   description: "A sword with a longer, more powerful blade.",
                   damageDealt: 8)
    }
}

class GreatSword: WeaponItem {
    init() {
        super.init(name: "Great Sword",
                   rarity: .uncommon,
                   goldValue: 20,
                   description: "A massive sword with a thick, heavy blade.",
                   damageDealt: 12)
    }
}

class MithrilSword: WeaponItem {
    init() {
        super.init(name: "Mithril Sword",
                   rarity: .rare,
                   goldValue: 25,
                   description: "A sword made of mithril, a rare and powerful metal.",
                   damageDealt: 16)
    }
}

class Excalibur: WeaponItem {
    init() {
        super.init(name: "Excalibur",
                   rarity: .legendary,
                   goldValue: 30,
                   description: "The legendary sword of King Arthur, said to be the most powerful weapon in the world.",
                   damageDealt: 20)
    }
}

class Dagger: WeaponItem {
    init() {
        super.init(name: "Dagger",
                   rarity: .common,
                   goldValue: 5,
                   description: "A small, sharp knife that can be used as a weapon or tool.",
                   damageDealt: 3)
    }
}

class Kris: WeaponItem {
    init() {
        super.init(name: "Kris",
                   rarity: .common,
                   goldValue: 8,
                   description: "A traditional Indonesian dagger with a wavy blade.",
                   damageDealt: 6)
    }
}

class Stiletto: WeaponItem {
    init() {
        super.init(name: "Stiletto",
                   rarity: .uncommon,
                   goldValue: 10,
                   description: "A long, slender blade with a sharp point, designed for piercing.",
                   damageDealt: 8)
    }
}

class Rapier: WeaponItem {
    init() {
        super.init(name: "Rapier",
                   rarity: .uncommon,
                   goldValue: 12,
                   description: "A slender, lightweight sword with a sharp point, designed for fencing.",
                   damageDealt: 10)
    }
}

class Katana: WeaponItem {
    init() {
        super.init(name: "Katana",
                   rarity: .rare,
                   goldValue: 15,
                   description: "A Japanese sword with a curved, single-edged blade.",
                   damageDealt: 12)
    }
}

class Claymore: WeaponItem {
    init() {
        super.init(name: "Claymore",
                   rarity: .rare,
                   goldValue: 17,
                   description: "A Scottish sword with a double-edged blade, designed for two-handed use.",
                   damageDealt: 15)
    }
}

class HealthPotion: HealingItem {
    init() {
        super.init(name: "Health Potion",
                   rarity: .common,
                   goldValue: 5,
                   description: "A potion that restores health points when consumed.",
                   amountHealed: 10)
    }
}

class HealingHerb: HealingItem {
    init() {
        super.init(name: "Healing Herb",
                   rarity: .common,
                   goldValue: 5,
                   description: "A herb that can be used to restore health points.",
                   amountHealed: 5)
    }
}

class HealingRoot: HealingItem {
    init() {
        super.init(name: "Healing Root",
                   rarity: .uncommon,
                   goldValue: 10,
                   description: "A root that can be used to restore health points.",
                   amountHealed: 12)
    }
}

class HealingFruit: HealingItem {
    init() {
        super.init(name: "Healing Fruit",
                   rarity: .rare,
                   goldValue: 15,
                   description: "A fruit that can be used to restore health points.",
                   amountHealed: 20)
    }
}

class Elixir: HealingItem {
    init() {
        super.init(name: "Elixir",
                   rarity: .legendary,
                   goldValue: 75,
                   description: "A magical potion that can restore all health points.",
                   amountHealed: 100)
    }
}

class Bandage: HealingItem {
    init() {
        super.init(name: "Bandage",
                   rarity: .common,
                   goldValue: 1,
                   description: "A strip of cloth used to cover a wound and stop bleeding.",
                   amountHealed: 3)
    }
}

class WoodenShield: DefensiveItem {
    init() {
        super.init(name: "Wooden Shield",
                   rarity: .common,
                   goldValue: 5,
                   description: "A basic shield made of wood.",
                   damageAbsorbed: 5)
    }
}

class IronShield: DefensiveItem {
    init() {
        super.init(name: "Iron Shield",
                   rarity: .uncommon,
                   goldValue: 10,
                   description: "A shield made of iron, stronger than a wooden shield.",
                   damageAbsorbed: 8)
    }
}

class SteelShield: DefensiveItem {
    init() {
        super.init(name: "Steel Shield",
                   rarity: .rare,
                   goldValue: 15,
                   description: "A shield made of steel, stronger than an iron shield.",
                   damageAbsorbed: 12)
    }
}

class MithrilShield: DefensiveItem {
    init() {
        super.init(name: "Mithril Shield",
                   rarity: .legendary,
                   goldValue: 20,
                   description: "A shield made of mithril, a rare and powerful metal.",
                   damageAbsorbed: 16)
    }
}

class MagicShield: DefensiveItem {
    init() {
        super.init(name: "Magic Shield",
                   rarity: .legendary,
                   goldValue: 25,
                   description: "A magical shield that can absorb a large amount of damage.",
                   damageAbsorbed: 20)
    }
}

class FireScroll: MagicItem {
    init() {
        super.init(name: "Fire Scroll",
                   rarity: .rare,
                   goldValue: 25,
                   description: "A scroll that summons a burst of fire when used.",
                   damageDealt: 10,
                   lootChance: 1)
    }
    override func use() {
        enemy.currentHP -= damageDealt * player.level
        let onFire = OnFire(target: enemy)
        enemy.addDebuff(debuff: onFire)
        print("\(enemy.name) is on fire!")
    }
}

class IceScroll: MagicItem {
    init() {
        super.init(name: "Ice Scroll",
                   rarity: .rare,
                   goldValue: 25,
                   description: "A scroll that summons a burst of ice when used.",
                   damageDealt: 9,
                   lootChance: 1)
    }
    override func use() {
        enemy.currentHP -= damageDealt * player.level
        let frozen = Reposed(target: enemy)
        enemy.addDebuff(debuff: frozen)
        print("\(enemy.name) is frozen!")
    }
}

class LightningScroll: MagicItem {
    init() {
        super.init(name: "Lightning Scroll",
                   rarity: .legendary,
                   goldValue: 25,
                   description: "A scroll that summons a burst of lightning when used.",
                   damageDealt: 15,
                   lootChance: 1)
    }
}

class EarthScroll: MagicItem {
    init() {
        super.init(name: "Earth Scroll",
                   rarity: .rare,
                   goldValue: 25,
                   description: "A scroll that summons a burst of earth when used.",
                   damageDealt: 8,
                   lootChance: 1)
    }
}

class WindScroll: MagicItem {
    init() {
        super.init(name: "Wind Scroll",
                   rarity: .common,
                   goldValue: 25,
                   description: "A scroll that summons a burst of wind when used.",
                   damageDealt: 5,
                   lootChance: 1)
    }
}

class WaterScroll: MagicItem {
    init() {
        super.init(name: "Water Scroll",
                   rarity: .common,
                   goldValue: 25,
                   description: "A scroll that summons a burst of water when used.",
                   damageDealt: 5,
                   lootChance: 1)
    }
}

class PoisonScroll: MagicItem {
    init() {
        super.init(name: "Poison Scroll",
                   rarity: .rare,
                   goldValue: 30,
                   description: "A scroll that summons a burst of poison when used.",
                   damageDealt: 20,
                   lootChance: 1)
    }
    override func use() {
        enemy.currentHP -= damageDealt * player.level
        let poisoned = Poisoned(target: enemy)
        enemy.addDebuff(debuff: poisoned)
    }
}

class LifeScroll: MagicItem {
    init() {
        super.init(name: "Life Scroll",
                   rarity: .legendary,
                   goldValue: 45,
                   description: "A scroll that summons a burst of life energy when used.",
                   damageDealt: 25,
                   lootChance: 1)
    }
}

class DeathScroll: MagicItem {
    init() {
        super.init(name: "Death Scroll",
                   rarity: .legendary,
                   goldValue: 45,
                   description: "A scroll that summons a burst of dark energy when used.",
                   damageDealt: 30,
                   lootChance: 1)
    }
}



