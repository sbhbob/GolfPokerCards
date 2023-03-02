//
//  Player.swift
//  Death Towards Life
//
//  Created by Skyler Hope on 12/29/22.
//

import Foundation

class Entity {
    var activeDebuffs: [Debuff] = []
    
    func addDebuff(debuff: Debuff) {
        activeDebuffs.append(debuff)
    }
}

let maxHealthPerLevel: [Int] = [20, 23, 26, 30, 34, 40, 46, 52, 60, 68, 79, 91, 105, 121, 139, 161, 186, 216, 251, 291]

class Player: Entity {
    var currentHP: Int = 5
    var maxHP: Int {
        return maxHealthPerLevel[level - 1]
    }
    
    var gold: Int = 0
    var name: String = "Grunt"
    var equippedWeapon: WeaponItem?
    var equippedShield: DefensiveItem?
    var spellList: [PlayerMagic] = []
    var fogOfWar: Int16 = 1
    
    var calculatedAtk: Int {
        return equippedWeapon?.damageDealt ?? 5
    }
    
    var atk: Int = 0
    
    var inventory: [Items] = []
    var experience: Int = 0
    var level: Int = 1
    var activePerks: [Perks] = []

    func melee(target: inout Enemy) {
        target.currentHP -= equippedWeapon!.damageDealt
    }

    func takeDamage(damage: Int) {
        currentHP -= damage
    }


        // ... Other classes and methods

    func startBattle(player: Player, enemy: Enemy) {
        // ... Other code
        
        while player.currentHP > 0 && enemy.currentHP > 0 {
            // ... Other code
            
            // Apply any active debuffs to the
            
        } }
    

    
    
    // experience system
    let baseExp = 100
    let expPerLevel = 50
    
    func awardExperience(experience: Int) {
        self.experience += experience
        checkLevelUp()
    }

    func checkLevelUp() {
        if level >= 20 {
            return
        }

        let expToNextLevel = baseExp + (level * expPerLevel) + (Int(Double(baseExp + (level * expPerLevel)) * 0.1))
        if experience >= expToNextLevel {
            level += 1
            experience -= expToNextLevel
            print("Level up!")
        }
    }
}
