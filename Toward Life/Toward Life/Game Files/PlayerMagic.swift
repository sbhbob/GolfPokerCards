//
//  PlayerMagic.swift
//  Death Towards Life
//
//  Created by Skyler Hope on 12/29/22.
//

import Foundation

class PlayerMagic {
    let name: String
    let description: String
    var damage: Int
    let level: Int
    let magicType: MagicType
    let player: Player = GameManager.shared.currentPlayer
    let enemy: Enemy = BattleManager.shared.enemy
    
    init(name: String, description: String, damage: Int, level: Int, magicType: MagicType) {
        self.name = name
        self.description = description
        self.damage = damage
        self.level = level
        self.magicType = magicType
    }
}

enum MagicType {
    case life
    case death
}

// MARK: Life Magic

class LifeMagic: PlayerMagic {
    var amountHealed: Int
    init(name: String, description: String, damage: Int, amountHealed: Int, level: Int) {
        self.amountHealed = amountHealed
        super.init(name: name,
                   description: description,
                   damage: damage,
                   level: level,
                   magicType: .life)
    }
}

// MARK: Level One Life Magic

class LevelOneLifeMagic: LifeMagic {
    init(name: String, description: String, amountHealed: Int, damage: Int) {
        super.init(name: name,
                   description: description,
                   damage: damage,
                   amountHealed: amountHealed,
                   level: 1)
    }
}

class Uplift: LevelOneLifeMagic {
    init() {
        super.init(name: "Uplift",
                   description: "Heals a small amount of damage.",
                   amountHealed: 3,
                   damage: 0)
    }
    func use() {
        guard player.currentHP < player.maxHP else { return }
        player.currentHP += amountHealed * player.level
        if player.currentHP > player.maxHP {
            player.currentHP = player.maxHP
        }
    }
}

class Growth: LevelOneLifeMagic {
    init() {
        super.init(name: "Growth",
                   description: "Raises attack a small amount",
                   amountHealed: 0,
                   damage: 0)
    }
    func use() {
        player.addDebuff(debuff: GrowthBuff(target: player))
    }
}

class Bake: LevelOneLifeMagic {
    init() {
        super.init(name: "Bake",
                   description: "Invokes the power of a convection oven to bake the enemy and make a healing tart",
                   amountHealed: 3,
                   damage: 5)
    }
    func use() {
        enemy.currentHP -= damage * player.level
        enemy.addDebuff(debuff: OnFire(target: enemy))
        guard player.currentHP < player.maxHP else { return }
        player.currentHP += amountHealed * player.level
        if player.currentHP > player.maxHP {
            player.currentHP = player.maxHP
        }
    }
}

class LevelTwoLifeMagick: LifeMagic {
    init(name: String, description: String, amountHealed: Int, damage: Int) {
        super.init(name: name,
                   description: description,
                   damage: damage,
                   amountHealed: amountHealed,
                   level: 2)
    }
}

class VineWrap: LevelTwoLifeMagick {
    init() {
        super.init(name: "Vine Wrap",
                   description: "Thirsty vines wrap your enemy, leeching you life. A thirst trap, if you will.",
                   amountHealed: 7,
                   damage: 12)
    }
    func use() {
        enemy.addDebuff(debuff: VineWrapD(target: enemy))
    }
}

class Energize: LevelTwoLifeMagick {
    init() {
        super.init(name: "Energize",
                   description: "You energize your melee attack",
                   amountHealed: 0,
                   damage: 8)
    }
    func use() {
        enemy.currentHP -= player.atk + (damage * player.level)
    }
}

class Reflect: LevelTwoLifeMagick {
    init() {
        super.init(name: "Reflect",
                   description: "Repeat the enemies next attack back at them, but better",
                   amountHealed: 0,
                   damage: 0)
    }
    func use() {
        enemy.addDebuff(debuff: ReflectD(target: enemy))
    }
}

class LevelThreeLifeMagic: LifeMagic {
    init(name: String, description: String, amountHealed: Int, damage: Int) {
        super.init(name: name,
                   description: description,
                   damage: damage,
                   amountHealed: amountHealed,
                   level: 3)
    }
}

class GiveLife: LevelThreeLifeMagic {
    init() {
        super.init(name: "Give Life",
                   description: "Heal for a butload",
                   amountHealed: 20,
                   damage: 0)
    }
    func use() {
        guard player.currentHP < player.maxHP else { return }
        player.currentHP += amountHealed * player.level
        if player.currentHP > player.maxHP {
            player.currentHP = player.maxHP
        }
    }
}

class Flood: LevelThreeLifeMagic {
    init() {
        super.init(name: "Flood",
                   description: "Flood the arena, dealing big damage to the enemy and taking life force from the waters",
                   amountHealed: 5,
                   damage: 18)
    }
    func use() {
        enemy.currentHP -= damage * player.level
        guard player.currentHP < player.maxHP else { return }
        player.currentHP += amountHealed * player.level
        if player.currentHP > player.maxHP {
            player.currentHP = player.maxHP
        }
    }
}

class Nothing: LevelThreeLifeMagic {
    var usedOnce: Bool = false
    init() {
        super.init(name: "Nothing",
                   description: "Decimates one enemy per run.",
                   amountHealed: 0,
                   damage: 0)
    }
    func use() {
        if usedOnce == false {
            enemy.currentHP = 0
            usedOnce = true
        }
        if usedOnce == true {
            print("  ...  ")
        }
    }
}

// MARK: Death Magic

class DeathMagic: PlayerMagic {
    init(name: String, description: String, damage: Int, level: Int) {
        super.init(name: name,
                   description: description,
                   damage: damage,
                   level: level,
                   magicType: .death)
    }
}

// MARK: Level One Death Magic

class LevelOneDeathMagic: DeathMagic {
    init(name: String, description: String, damage: Int) {
        super.init(name: name,
                   description: description,
                   damage: damage,
                   level: 1)
    }
}


class ShadowBolt: LevelOneDeathMagic {
    init() {
        super.init(name: "Shadow Bolt",
                   description: "an offensive spell that deals low damage to a single target.",
                   damage: 12)
    }
    
    func use() {
        enemy.currentHP -= damage * player.level
    }
}

class DeathGrip: LevelOneDeathMagic {
    let stunDuration: Int = 1
    
    init() {
        super.init(name: "Death Grip",
                   description: "an offensive spell that deals low damage to a single target and has a chance to stun the target for one turn.",
                   damage: 8)
    }
    
    func use() {
        enemy.currentHP -= damage * player.level
        var range: Int {
            Int.random(in: 1...6)
        }
        if range == 1 {
            enemy.addDebuff(debuff: Reposed(target: enemy))
        }
    }
}

class DeathsEmbrace: LevelOneDeathMagic {

    init() {
        super.init(name: "Death's Embrace",
                   description: "Deals low damage to a single target and applies a debuff that reduces their attack power for a duration.",
                   damage: 7)
    }

    func use() {
        enemy.currentHP -= damage
        enemy.addDebuff(debuff: Cursed(target: enemy))
    }
}

// MARK: Level Two Death Magic

class LevelTwoDeathMagic: DeathMagic {
    init(name: String, description: String, damage: Int) {
        super.init(name: name,
                   description: description,
                   damage: damage,
                   level: 2)
    }
}

class CrypticBlast: LevelTwoDeathMagic {
    init() {
        super.init(name: "Cryptic Blast",
                   description: "An offensive spell that deals high damage to all targets.",
                   damage: 18)
    }
    
    func use() {
        enemy.currentHP -= damage * player.level
    }
}

class ShadowNova: LevelTwoDeathMagic {
    let stunDuration: Int = 1
    
    init() {
        super.init(name: "Shadow Nova",
                   description: "An offensive spell that deals moderate damage to all targets and has a better chance to stun them for one turn.",
                   damage: 14)
    }
    
    func use() {
        enemy.currentHP -= damage * player.level
        var range: Int {
            Int.random(in: 1...3)
        }
        if range == 1 {
            enemy.addDebuff(debuff: Reposed(target: enemy))
        }
        
    }
}

class ForbiddenCurse: LevelTwoDeathMagic {
    init() {
        super.init(name: "Forbidden Curse",
                   description: "Deals moderate damage to a single target and applies a debuff that is guaranteed to reduce their attack power.",
                   damage: 18)
    }
    
    func use() {
        enemy.currentHP -= damage * player.level
        enemy.addDebuff(debuff: Cursed(target: enemy))
    }
}

// MARK: Level Three Death Magic

class LevelThreeDeathMagic: DeathMagic {
    init(name: String, description: String, damage: Int) {
        super.init(name: name,
                   description: description,
                   damage: damage,
                   level: 3)
    }
}

class NecroticFrost: LevelThreeDeathMagic {
    init() {
        super.init(name: "Necrotic Frost",
                   description: "An offensive spell that deals high damage to a single target and rots them with a chance to freeze them.",
                   damage: 20)
    }
    
    func use() {
        enemy.currentHP -= damage * player.level
        enemy.addDebuff(debuff: Rotting(target: enemy))

        var range: Int {
            Int.random(in: 1...3)
        }
        if range == 1 {
            enemy.addDebuff(debuff: Reposed(target: enemy))
        }
    }
}

class ShadowBlast: LevelThreeDeathMagic {
    init() {
        super.init(name: "Shadow Blast",
                   description: "An offensive spell that deals massive damage to all targets in a small radius.",
                   damage: 25)
    }
    
    func use() {
        enemy.currentHP -= damage * player.level
    }
}

class TabletShatter: LevelThreeDeathMagic {
    let curseDuration: Int = 3
    
    init() {
        super.init(name: "Tablet Shatter",
                   description: "Shatters a clay tablet with the enemies true name enscribed on it, dealing high damage, cursing them with a high chance to apply the rotting debuff.",
                   damage: 20)
    }
    
    func use() {
        enemy.currentHP -= damage * player.level
        enemy.addDebuff(debuff: Cursed(target: enemy))
        var range: Int {
            Int.random(in: 1...2)
        }
        if range == 1 {
            enemy.addDebuff(debuff: Rotting(target: enemy))
        }
    }
}



