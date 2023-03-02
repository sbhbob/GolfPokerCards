//
//  Effects.swift
//  Death Towards Life
//
//  Created by Skyler Hope on 12/29/22.
//

import Foundation

class Debuff: Equatable {
    
    static func == (lhs: Debuff, rhs: Debuff) -> Bool {
        return lhs.title == rhs.title
    }
    
    
    let player: Player = GameManager.shared.currentPlayer
    let title: String
    let duration: Int
    var target: Entity
    var currentDuration: Int
    
    init(title: String, duration: Int, target: Entity) {
        self.title = title
        self.duration = duration
        self.target = target
        self.currentDuration = duration
    }
    
    func apply() {
        
    }
    func remove() {
        // Find the index of the debuff in the activeDebuffs array
        guard let index = target.activeDebuffs.firstIndex(where: { $0.title == title }) else { return }
        // Remove the debuff from the activeDebuffs array
        target.activeDebuffs.remove(at: index)
    }
}

class OnFire: Debuff {
    let damageDealt: Int = Int.random(in: 5...19)
    
    init(target: Entity) {
        super.init(title: "onFire", duration: 3, target: target)
    }
    
    override func apply() {
        if currentDuration == 0 {
            remove()
        }
        // Check if the target is an Enemy or a Player
        if let enemy = target as? Enemy {
            // Reduce the enemy's current HP by the damage dealt by the debuff
            enemy.currentHP -= damageDealt
            currentDuration -= 1
        } else if let player = target as? Player {
            // Reduce the player's current HP by the damage dealt by the debuff
            player.currentHP -= damageDealt
            currentDuration -= 1
        }
    }
}


class Contagion: Debuff {
    init(target: Entity) {
        super.init(title: "Contagion", duration: 4, target: target)
    }
    override func apply() {
        if currentDuration == 0 {
            remove()
        }
        // Check if the target is an Enemy or a Player
        if let enemy = target as? Enemy {
            enemy.atk = Int(Double(enemy.atk) * 0.75)
            currentDuration -= 1
        } else if let player = target as? Player {
            player.atk = Int(Double(player.atk) * 0.75)
            currentDuration -= 1
        }
    }
}

class Reposed: Debuff {
    
    init(target: Entity) {
        super.init(title: "Reposed", duration: 1, target: target)
    }
    override func apply() {
        if currentDuration == 0 {
            remove()
        }
        // Check if the target is an Enemy or a Player
        if let enemy = target as? Enemy {
            enemy.atk = 0
            currentDuration -= 1
        } else if let player = target as? Player {
            player.atk = 0
            currentDuration -= 1
        }
    }
}


    
class DarkBlessing: Debuff {
    // Store the original health of the entity
    var originalHealth: Int {
        if let enemy = target as? Enemy {
            return enemy.currentHP
        } else if let player = target as? Player {
            return player.currentHP
        } else {
            return 0
        }
    }
    // Store the damage dealt during the turn in which the debuff is active
    var damageDealt: Int = 0
    
    init(target: Entity) {
        super.init(title: "Dark Feast", duration: 2, target: target)
    }
    
    override func apply() {
        // Update the damage dealt during the turn in which the debuff is active
        self.damageDealt += damageDealt
        // Check if the debuff has expired
        if currentDuration == 0 {
            // Restore the entity's original health minus the damage dealt during the turn in which the debuff was active
            if let enemy = target as? Enemy {
                let damageDealt = originalHealth - enemy.currentHP
                enemy.currentHP = originalHealth - damageDealt
            } else if let player = target as? Player {
                let damageDealt = originalHealth - player.currentHP
                player.currentHP = originalHealth - damageDealt
            }
            // Reset the damage dealt variable
            self.damageDealt = 0
            // Remove the debuff from the active debuffs array
            remove()
        } else {
            // Check if the target is an Enemy or a Player
            if let enemy = target as? Enemy {
                let halvedHealth = enemy.currentHP / 2
                enemy.currentHP = halvedHealth
                currentDuration -= 1
            } else if let player = target as? Player {
                let halvedHealth = player.currentHP / 2
                player.currentHP = halvedHealth
                currentDuration -= 1
            }
        }
    }
}


class Poisoned: Debuff {
    init(target: Entity) {
        super.init(title: "Poisoned", duration: 4, target: target)
    }
    override func apply() {
        // Check if the debuff has expired
        if currentDuration == 0 {
            // Remove the debuff from the active debuffs array
            remove()
        } else {
            // Check if the target is an Enemy or a Player
            if let enemy = target as? Enemy {
                // Reduce the enemy's current HP by 3% of their maximum HP
                enemy.currentHP -= Int(Double(enemy.maxHP) * 0.03)
                currentDuration -= 1
            } else if
                let player = target as? Player {
                // Reduce the player's current HP by 3% of their maximum HP
                player.currentHP -= Int(Double(player.maxHP) * 0.03)
                currentDuration -= 1
            }
        }
    }
}

class Cursed: Debuff {
    // Store the original attack of the entity
    var originalAttack: Int {
        if let enemy = target as? Enemy {
            return enemy.atk
        } else if let player = target as? Player {
            return player.atk
        } else {
            return 0
        }
    }
    
    init(target: Entity) {
        super.init(title: "Cursed", duration: 3, target: target)
    }
    
    override func apply() {
        // Check if the debuff has expired
        if currentDuration == 0 {
            // Restore the entity's original attack value
            if let enemy = target as? Enemy {
                enemy.atk = originalAttack
            } else if let player = target as? Player {
                player.atk = originalAttack
            }
            // Remove the debuff from the active debuffs array
            remove()
        } else {
            // Check if the target is an Enemy or a Player
            if let enemy = target as? Enemy {
                // Halve the enemy's attack value
                enemy.atk = enemy.atk / 2
                currentDuration -= 1
            } else if let player = target as? Player {
                // Halve the player's attack value
                player.atk = player.atk / 2
                currentDuration -= 1
            }
        }
    }
}

class Rotting: Debuff {

    init(target: Entity) {
        super.init(title: "Rotting", duration: 2, target: target)
    }
    
    override func apply() {
        if currentDuration == 0 {
            remove()
        }
        // Check if the target is an Enemy or a Player
        if let enemy = target as? Enemy {
            // Reduce the enemy's max HP and healing received by 25%
            enemy.currentHP = Int(Double(enemy.currentHP) * 0.80)
            currentDuration -= 1
        } else if let player = target as? Player {
            // Reduce the player's max HP and healing received by 25%
            player.currentHP = Int(Double(player.currentHP) * 0.80)
            currentDuration -= 1
        }
    }
}


class GrowthBuff: Debuff {
    init(target: Entity) {
        super.init(title: "Growth", duration: 1, target: target)
    }
    
    override func apply() {
        let originalAtk: Int = player.atk
        if currentDuration == 0 {
            player.atk = originalAtk
            remove()
        }
        if let enemy = target as? Enemy {
            enemy.atk += Int(Double(enemy.atk) * 0.5)
            currentDuration -= 1
        } else if let player = target as? Player {
            player.atk += Int(Double(player.atk) * 0.5)
        }
    }
}

class VineWrapD: Debuff {
    init(target: Entity) {
        super.init(title: "Vine Wrap", duration: 3, target: target)
    }
    
    override func apply() {
        if currentDuration == 0 {
            remove()
        }
        if let target = target as? Enemy {
            target.currentHP -= 12 * player.level
            
            guard player.currentHP < player.maxHP else { return }
            player.currentHP += 7 * player.level
            if player.currentHP > player.maxHP {
                player.currentHP = player.maxHP
            }
            
        } else if target is Player {
            player.currentHP -= 12
        }
    }
}

class ReflectD: Debuff {
    init(target: Entity) {
        super.init(title: "Reflect", duration: 1, target: target)
    }
    
    override func apply() {
        if currentDuration == 0 {
            remove()
        }
        if let target = target as? Enemy {
            target.currentHP -= Int(Double(target.atk) * 1.5)
        } else if let target = target as? Player {
            target.currentHP -= Int(Double(target.atk) * 1.5)
        }
    }
}

