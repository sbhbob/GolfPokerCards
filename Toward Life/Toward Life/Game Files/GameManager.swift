//
//  GameManager.swift
//  Death Towards Life
//
//  Created by Skyler Hope on 12/29/22.
//

import Foundation

class GameManager {

    static let shared = GameManager()
    
    init() {
        currentPlayer = Player()
    }
    
    var currentPlayer: Player
    
    func createNewCharacter(name: String) -> Player {
        let player = Player()
        player.name = name
        player.atk = player.calculatedAtk
        player.currentHP = player.maxHP
        return player
        
        func startNewGame() {
            currentPlayer = player
            let shadowBolt = ShadowBolt()
            player.spellList.append(shadowBolt)
        }
    }
}

enum Turn {
    case enemyTurn
    case playerTurn
}

enum PlayerOptions {
    case meleeAttack
    case useItem
    case useSpell
    case run
}

class BattleManager {
    static let shared = BattleManager()
    private init() {}
    
    var enemy: Enemy = Skeleton() // initialized improperly
    let player: Player = GameManager.shared.currentPlayer
    var turn: Turn = .enemyTurn
    
    func determineEnemy() -> Enemy {
        return Skeleton() // shortcutted, needs to be filled out
    }
    
    func startBattle() {
        enemy = determineEnemy()
        
    }
    
    func applyDebuffs(entity: Entity) {
        guard entity.activeDebuffs != [] else { return }
        for debuff in entity.activeDebuffs {
            debuff.apply()
        }
    }
    


    func switchTurn() {
        if turn == .enemyTurn {
            turn = .playerTurn
        }
        if turn == .playerTurn {
            turn = .enemyTurn
        }
    }
    
//    func playerAction() {
//        let playerOption: PlayerOptions
//        switch playerOption {
//        case .meleeAttack:
//            player.melee(target: &enemy)
//        case .useSpell:
//            <#code#>
//        case .useItem:
//            useItem(item: <#T##Item#>)
//        case .run:
//            var range: Int { Int.random(in: 1...3) }
//            if range != 3 {
//                run()
//            }
//        }
//    }
    
    func run() {
        //exit battle
    }
    
    func useItem(item: Items) {
        item.use()
    }
    
//    func takeTurn() {
//        switch turn {
//        case .enemyTurn:
//            applyDebuffs(entity: enemy)
//            enemy.attack()
//            switchTurn()
//            
//        case .playerTurn:
//            applyDebuffs(entity: player)
//            switch _ {
//            case <#pattern#>:
//                <#code#>
//            default:
//                <#code#>
//            }
//            switchTurn()
//        }
//    }
    
    func playerDies() {
        player.gold = 0
        let shortsword = ShortSword()
        player.inventory = [shortsword]
        player.activeDebuffs = []
        player.currentHP = player.maxHP
    }
    
    func playerWins() {
        player.experience += enemy.experienceGiven
        player.checkLevelUp()
    }
    
//    func battle() {
//        while player.currentHP > 0 && enemy.currentHP > 0 {
//            takeTurn()
//        }
//        if player.currentHP <= 0 {
//            playerDies()
//        }
//        else if enemy.currentHP <= 0 {
//            playerWins()
//        }
//    }
}

