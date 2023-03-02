//
//  Enemies.swift
//  Death Towards Life
//
//  Created by Skyler Hope on 12/29/22.
//

import Foundation

// MARK: Enums

enum SpecialAbilities {
    case shadowStrike
    case ghostlyBlades
    case infernalBite
    case contagion
    case deathlyTouch
    case voidRift
    case demonFire
    case carrionCall
    case vampiricBite
    case darkBlessing
    case shadowStorm
    case poisonStrike
    case rottingTouch
    case lifeDrain
    case shadowBreath
    case curseStrike
    case deathStrike
    case voidBlast
    case darkHarvest
    case rainOfDeath
    case none
}

enum EnemyType {
    case mob
    case boss
}

// MARK: Enemy Classes

class Enemy: Entity {
    
    let name: String
    var currentHP: Int
    let maxHP: Int
    var specialAbility: SpecialAbilities
    
    let experienceGiven: Int
    let player: Player = GameManager.shared.currentPlayer
    
    var atk: Int
    
    init(name: String, atk: Int, specialAbility: SpecialAbilities, experienceGiven: Int, maxHP: Int) {
        self.name = name
        self.atk = atk
        self.specialAbility = specialAbility
        self.experienceGiven = experienceGiven * player.level
        self.maxHP = maxHP
        self.currentHP = maxHP
    }
    
    func use() {
        switch specialAbility{
        case .shadowStrike:
            currentHP -= Int(Double(currentHP) * 0.25)
            player.currentHP -= atk * 2
            print("\(name) used Shadow Strike and dealt double damage to the player. They took \(Int(Double(currentHP) * 0.25)) damage.")
            
        case .ghostlyBlades:
            // Deal normal damage to the target
            player.currentHP -= atk
            // Set the target on fire, dealing additional damage over time
            let onFire = OnFire(target: GameManager.shared.currentPlayer)
            player.addDebuff(debuff: onFire)
            
        case .infernalBite:
            // Deal normal damage to the target
            player.currentHP -= atk
            // Set the target on fire, dealing additional damage over time
            let onFire = OnFire(target: GameManager.shared.currentPlayer)
            player.addDebuff(debuff: onFire)
            
        case .contagion:
            // Deals normal damage and spreads a debuff that reduces the target's ATK by 25%
            let damage = atk
            player.currentHP -= Int(Double(damage) * 0.8)
            let contagion = Contagion(target: GameManager.shared.currentPlayer)
            player.addDebuff(debuff: contagion)
            
        case .deathlyTouch:
            player.currentHP -= atk * 3
            currentHP += atk
            
        case .voidRift: // can be used more often
            let coin = Int.random(in: 1...3)
            if coin == 1 {
                player.currentHP -= atk * 2
                print("\(name) opens a portal to the Void and pulls the target inside, dealing massive damage!")
            }
            else if coin == 2 {
                currentHP -= 5
                print("\(name): Whoops")
            }
            else {
                print("\(name) opens a portal to the Void and pulls the target inside!")
                print("You emerge unscathed.")
            }
            
        case .demonFire:
            currentHP -= Int(Double(currentHP) * 0.10)
            player.currentHP -= Int(Double(atk) * 2.2)
            print("\(name) uses Demon Fire and deals \(atk) damage to the player. A trail of flames is left behind.")
            
        case .carrionCall:
            let reposed = Reposed(target: GameManager.shared.currentPlayer)
            player.addDebuff(debuff: reposed)
            print("\(name) lets loose a deafening screech! \(name) is now reposed.")
            
        case .vampiricBite:
            player.currentHP -= Int(Double(atk) * 1.5)
            currentHP += Int(Double(atk) * 1.5)
            print("zubat used leech l- no, wait")
            print("\(name) used Vampiric Bite! \(name) stole your HP!")
            
        case .darkBlessing:
            let darkBlessing = DarkBlessing(target: GameManager.shared.currentPlayer)
            player.addDebuff(debuff: darkBlessing)
            print("Your health has been halved for one turn. Good luck not getting one-shot.")
            
        case .shadowStorm:
            let damage = Int(Double(atk) * 1.5)
            player.currentHP -= Int(Double(atk) * 1.5)
            print("\(name) unleashes a storm of shadows, dealing \(damage) damage to the target.")
            
        case .poisonStrike:
            let damage = atk
            player.currentHP -= damage
            // Set the target to be poisoned, dealing additional damage over time
            let poisoned = Poisoned(target: GameManager.shared.currentPlayer)
            player.addDebuff(debuff: poisoned)
            
        case .rottingTouch:
            let damage = atk
            player.currentHP -= damage
            // Set the target to be rotting, reducing their max HP and healing received by 25%
            let rotting = Rotting(target: GameManager.shared.currentPlayer)
            player.addDebuff(debuff: rotting)
            
        case .lifeDrain:
            // Deals normal damage and restores some of the enemy's HP
            let damage = atk
            player.currentHP -= damage
            currentHP += Int(Double(damage) * 0.25)
            
        case .shadowBreath:
            // Deals heavy damage to all targets in a cone in front of the enemy
            let damage = Int(Double(atk) * 1.5)
            player.currentHP -= damage
            
        case .curseStrike:
            // Deals normal damage and applies a debuff that reduces the target's ATK by 50%
            player.currentHP -= atk
            let cursed = Cursed(target: GameManager.shared.currentPlayer)
            player.addDebuff(debuff: cursed)
            
        case .deathStrike:
            // Deals massive damage to the target, but can only be used if the enemy's HP is below 20%
            if currentHP < Int(Double(currentHP) * 0.2) {
                player.currentHP -= Int(Double(atk) * 0.75)
                print("(enemy.name) uses death strike and deals massive damage to the target!")
            }
            else {
                print("(enemy.name) is too low enough on HP to use death strike.")
            }
            
        case .voidBlast:
            player.currentHP -= atk / 2
            let reposed = Reposed(target: GameManager.shared.currentPlayer)
            player.addDebuff(debuff: reposed)
            
        case .darkHarvest:
            let damage = Int(Double(atk) * 3)
            player.currentHP -= Int(Double(atk) * 3)
            // check if enemy is rotting, apply 75% healing
            if activeDebuffs.contains(where: { $0 is Rotting }) {
                // Reduce the healing by 25%
                currentHP += Int(Double(damage) * 0.75)
            } else {
                // Healing is not reduced
                currentHP += damage
            }
            
        case .rainOfDeath:
            var usedOnce = false // MARK: set this back to false when someone dies
            // Deals massive damage to all targets, but can only be used once per battle
            if usedOnce == false {
                player.currentHP -= Int(Double(atk) * 2.5)
                usedOnce = true
                print("\(name) unleashes a Rain of Death, dealing massive damage to all targets!")
            }
            if usedOnce == true {
                print("Nothing happened!")
            }
        case .none:
            print(arrayOfSounds.randomElement()!)
        }
    }
    
    func attack() {
        player.currentHP -= atk
    }
}

// MARK: Mobs

class Mob: Enemy {
    init(name: String, atk: Int, experienceGiven: Int, maxHP: Int) {
        super.init(name: name, atk: atk, specialAbility: .none, experienceGiven: experienceGiven, maxHP: maxHP)
    }
}


class Mob1: Mob {
    override init(name: String, atk: Int, experienceGiven: Int, maxHP: Int) {
        super.init(name: name, atk: atk, experienceGiven: experienceGiven, maxHP: maxHP)
    }
}
    
class Skeleton: Mob1 {
    init() {
        super.init(name: "Skeleton",
                   atk: Int.random(in: 2...5),
                   experienceGiven: 5,
                   maxHP: 20)
    }
}

class Goblin: Mob1 {
    init() {
        super.init(name: "Goblin",
                   atk: Int.random(in: 3...5),
                   experienceGiven: 10,
                   maxHP: 20)
    }
}

class Ghoul: Mob1 {
    init() {
        super.init(name: "Ghoul",
                   atk: Int.random(in: 4...5),
                   experienceGiven: 15,
                   maxHP: 20)
    }
}

class Mob2: Mob {
    override init(name: String, atk: Int, experienceGiven: Int, maxHP: Int) {
        super.init(name: name, atk: atk, experienceGiven: experienceGiven, maxHP: maxHP)
    }
    
    override func attack() {
        player.currentHP -= atk
        var range: Int { Int.random(in: 1...8) }
        if range == 1 {
            let player = GameManager.shared.currentPlayer
            let poisoned = Poisoned(target: player)
            player.addDebuff(debuff: poisoned)
            print("You've been poisoned!")
        }
    }
}
    
class CorpseFlower: Mob2 {
    init() {
        super.init(name: "Corspe Flower",
                   atk: Int.random(in: 4...9),
                   experienceGiven: 15,
                   maxHP: 25)
    }
}

class DevilStick: Mob2 {
    init() {
        super.init(name: "Devil's Walking Stick",
                   atk: Int.random(in: 5...9),
                   experienceGiven: 20,
                   maxHP: 25)
    }
}

class GhostMushroom: Mob2 {
    init() {
        super.init(name: "Ghost Mushroom",
                   atk: Int.random(in: 6...9),
                   experienceGiven: 25,
                   maxHP: 25)
    }
}

class Mob3: Mob {
    override init(name: String, atk: Int, experienceGiven: Int, maxHP: Int) {
        super.init(name: name, atk: atk, experienceGiven: experienceGiven, maxHP: maxHP)
    }
    
    override func attack() {
        player.currentHP -= atk
        var range: Int { Int.random(in: 1...5) }
        if range == 1 {
            let player = GameManager.shared.currentPlayer
            let onFire = OnFire(target: player)
            player.addDebuff(debuff: onFire)
            print("You're on fire!")
        }
    }
}
    
class Chimera: Mob3 {
    init() {
        super.init(name: "Chimera",
                   atk: Int.random(in: 10...15),
                   experienceGiven: 25,
                   maxHP: 30)
    }
}

class Lampad: Mob3 {
    init() {
        super.init(name: "Lampad",
                   atk: Int.random(in: 11...15),
                   experienceGiven: 25,
                   maxHP: 30)
    }
}

class Cherufe: Mob3 {
    init() {
        super.init(name: "Cherufe",
                   atk: Int.random(in: 12...15),
                   experienceGiven: 30,
                   maxHP: 30)
    }
}

class Mob4: Mob {
    override init(name: String, atk: Int, experienceGiven: Int, maxHP: Int) {
        super.init(name: name, atk: atk, experienceGiven: experienceGiven, maxHP: maxHP)
    }
    
    override func attack() {
        player.currentHP -= atk
        var range: Int { Int.random(in: 1...3) }
        if range == 1 {
            let player = GameManager.shared.currentPlayer
            let contagion = Contagion(target: player)
            player.addDebuff(debuff: contagion)
            print("You've been infected with a contagion...")
        }
    }
}

class PlagueRat: Mob4 {
    init() {
        super.init(name: "Plague Rat",
                   atk: Int.random(in: 5...20),
                   experienceGiven: 40,
                   maxHP: 40)
    }
}

class Zombie: Mob4 {
    init() {
        super.init(name: "Zombie",
                   atk: Int.random(in: 5...20),
                   experienceGiven: 40,
                   maxHP: 40)
    }
}

class PlagueDoctor: Mob4 {
    init() {
        super.init(name: "Plague Doctor", atk: Int.random(in: 10...20), experienceGiven: 50, maxHP: 45)
    }
}

class Mob5: Mob {
    override init(name: String, atk: Int, experienceGiven: Int, maxHP: Int) {
        super.init(name: name, atk: atk, experienceGiven: experienceGiven, maxHP: maxHP)
    }
    
    override func attack() {
        player.currentHP -= atk
        var range: Int { Int.random(in: 1...10) }
        if range == 1 {
            let player = GameManager.shared.currentPlayer
            let rotting = Rotting(target: player)
            player.addDebuff(debuff: rotting)
            print("You're innards begin to rot...")
        }
    }
}

class Mummy: Mob5 {
    init() {
        super.init(name: "Mummy",
                   atk: Int.random(in: 1...30),
                   experienceGiven: 65,
                   maxHP: 40)
    }
}

class SwampCarcass: Mob5 {
    init() {
        super.init(name: "Swamp Carcass",
                   atk: Int.random(in: 1...30),
                   experienceGiven: 70,
                   maxHP: 50)
    }
}

class UndeadVulture: Mob5 {
    init() {
        super.init(name: "Undead Vulture",
                   atk: Int.random(in: 1...30),
                   experienceGiven: 75,
                   maxHP: 45)
    }
}

// MARK: Bosses

class Boss: Enemy {
    let enemyType: EnemyType = .boss
    let specialAbilityName: String
    let specialAbilityDescription: String
    
    init(name: String, atk: Int,  specialAbility: SpecialAbilities, specialAbilityName: String, specialAbilityDescription: String, experienceGiven: Int, maxHP: Int)
    {
        self.specialAbilityDescription = specialAbilityDescription
        self.specialAbilityName = specialAbilityName
        super.init(name: name, atk: atk, specialAbility: specialAbility, experienceGiven: experienceGiven, maxHP: maxHP)
    }
    
    override func attack() {
        var range: Int { Int.random(in: 1...6) }
        if range == 1 {
            use()
        }
        else {
            player.currentHP -= atk
        }
    }
}

class ShadowStalker: Boss {
    init() {
        super.init(name: "Shadow Stalker",
                   atk: Int.random(in: 9...15),
                   specialAbility: .shadowStrike,
                   specialAbilityName: "Shadow Strike",
                   specialAbilityDescription: "Deals double damage but also reduces the Shadow Stalker's HP by 25%",
                   experienceGiven: 10,
                   maxHP: 60)
    }
}

class SpectralAssassin: Boss {
    init() {
        super.init(name: "Spectral Assassin",
                   atk: Int.random(in: 12...18),
                   specialAbility: .ghostlyBlades,
                   specialAbilityName: "Ghostly Blades",
                   specialAbilityDescription: "Attacks twice in a row, each attack dealing 75% of normal damage",
                   experienceGiven: 11,
                   maxHP: 80)
    }
}

class DemonHound: Boss {
    init() {
        super.init(name: "Demon Hound",
                   atk: Int.random(in: 15...20),
                   specialAbility: .infernalBite,
                   specialAbilityName: "Infernal Bite",
                   specialAbilityDescription: "Deals normal damage and also sets the target on fire, dealing additional damage over time",
                   experienceGiven: 12,
                   maxHP: 100)
    }
}


class PlagueZombie: Boss {
    init() {
        super.init(name: "Plague Zombie",
                   atk: Int.random(in: 18...23),
                   specialAbility: .contagion,
                   specialAbilityName: "Contagion",
                   specialAbilityDescription: "Deals normal damage and also spreads a debuff that reduces the target's ATK by 25%",
                   experienceGiven: 13,
                   maxHP: 120)
    }
}

class NecroticRevenant: Boss {
    init() {
        super.init(name: "Necrotic Revenant",
                   atk: Int.random(in: 18...26),
                   specialAbility: .deathlyTouch, specialAbilityName: "Deathly Touch", specialAbilityDescription: "Deals normal damage and also drains the target's HP, healing the Necrotic Revenant for an amount equal to the damage dealt", experienceGiven: 15, maxHP: 140)
    }
}

class Voidwalker: Boss {
    init() {
        super.init(name: "Voidwalker",
                   atk: Int.random(in: 18...29),
                   specialAbility: .voidRift,
                   specialAbilityName: "Void Rift",
                   specialAbilityDescription: "Opens a portal to the Void, pulling the target inside and dealing massive damage",
                   experienceGiven: 16,
                   maxHP: 160)
    }
}

class InfernalImp: Boss {
    init() {
        super.init(name: "Infernal Imp",
                   atk: Int.random(in: 18...32),
                   specialAbility: .demonFire,
                   specialAbilityName: "Demonfire",
                   specialAbilityDescription: "Deals normal damage and also leaves a trail of flames that damages any enemy that passes through it",
                   experienceGiven: 18,
                   maxHP: 180)
    }
}

class CarrionCrow: Boss {
    init() {
        super.init(name: "Carrion Crow",
                   atk: Int.random(in: 18...35),
                   specialAbility: .carrionCall,
                   specialAbilityName: "Carrion Call",
                   specialAbilityDescription: "Summons additional Carrion Crows to attack the target",
                   experienceGiven: 20,
                   maxHP: 200)
    }
}

class BloodthirstyBat: Boss {
    init() {
        super.init(name: "Bloodthirsty Bat",
                   atk: Int.random(in: 18...38),
                   specialAbility: .vampiricBite,
                   specialAbilityName: "Vampiric Bite",
                   specialAbilityDescription: "Deals normal damage and also drains the target's HP, healing the Bloodthirsty Bat for an amount equal to the damage dealt",
                   experienceGiven: 22,
                   maxHP: 220)
    }
}


class DarkPriest: Boss {
    init() {
        super.init(name: "Dark Priest",
                   atk: Int.random(in: 18...41),
                   specialAbility: .darkBlessing,
                   specialAbilityName: "Dark Blessing",
                   specialAbilityDescription: "Increases the attack power of all enemy units by 25% for 3 turns",
                   experienceGiven: 24,
                   maxHP: 240)
    }
}

class ShadowElemental: Boss {
    init() {
        super.init(name: "Shadow Elemental",
                   atk: Int.random(in: 25...44),
                   specialAbility: .shadowStorm,
                   specialAbilityName: "Shadow Storm",
                   specialAbilityDescription: "Deals massive damage to all enemies and reduces their attack power by 25% for 3 turns",
                   experienceGiven: 26,
                   maxHP: 260)
    }
}

class PoisonDartFrog: Boss {
    init() {
        super.init(name: "Poison Dart Frog",
                   atk: Int.random(in: 25...47),
                   specialAbility: .poisonStrike,
                   specialAbilityName: "Poison Strike",
                   specialAbilityDescription: "Deals normal damage and also poisons the target, dealing additional damage over time",
                   experienceGiven: 29,
                   maxHP: 280)
    }
}

class DecomposingGolem: Boss {
    init() {
        super.init(name: "Decomposing Golem",
                   atk: Int.random(in: 25...50),
                   specialAbility: .rottingTouch,
                   specialAbilityName: "Rotting Touch",
                   specialAbilityDescription: "Deals normal damage and also spreads a debuff that reduces the target's DEF by 50%",
                   experienceGiven: 32,
                   maxHP: 300)
    }
}

class lifeStealer: Boss {
    init() {
        super.init(name: "Life Stealer",
                   atk: Int.random(in: 25...53),
                   specialAbility: .lifeDrain,
                   specialAbilityName: "Life Drain",
                   specialAbilityDescription: "Deals normal damage and also drains the target's HP, healing the Life Stealer for an amount equal to the damage dealt",
                   experienceGiven: 35,
                   maxHP: 320)
    }
}

class ShadowDragon: Boss {
    init() {
        super.init(name: "Shadow Dragon",
                   atk: Int.random(in: 25...56),
                   specialAbility: .shadowBreath,
                   specialAbilityName: "Shadow Breath",
                   specialAbilityDescription: "Deals massive damage to all enemy units and also reduces their DEF by 50% for 3 turns",
                   experienceGiven: 38,
                   maxHP: 340)
    }
}

class CurseSlinger: Boss {
    init() {
        super.init(name: "Curse Slinger",
                   atk: Int.random(in: 25...59),
                   specialAbility: .curseStrike,
                   specialAbilityName: "Curse Strike",
                   specialAbilityDescription: "Deals normal damage and also curses the target, reducing their luck by 50% for 3 turns",
                   experienceGiven: 42,
                   maxHP: 360)
    }
}

class DeathKnight: Boss {
    init() {
        super.init(name: "Death Knight",
                   atk: Int.random(in: 25...62),
                   specialAbility: .deathStrike,
                   specialAbilityName: "Death Strike",
                   specialAbilityDescription: "Deals normal damage and also has a 50% chance to instantly kill the target",
                   experienceGiven: 46,
                   maxHP: 380)
    }
}

class VoidMage: Boss {
    init() {
        super.init(name: "Void Mage",
                   atk: Int.random(in: 35...65),
                   specialAbility: .voidBlast,
                   specialAbilityName: "Void Blast",
                   specialAbilityDescription: "Opens a portal to the Void and pulls the target inside, dealing massive damage",
                   experienceGiven: 51,
                   maxHP: 400)
    }
}

class Necromancer: Boss {
    init() {
        super.init(name: "Necromancer",
                   atk: Int.random(in: 35...68),
                   specialAbility: .darkHarvest,
                   specialAbilityName: "Dark Harvest",
                   specialAbilityDescription: "Adds a bunch of health to the Necromancer",
                   experienceGiven: 56,
                   maxHP: 420)
    }
}

class ShadowOverlord: Boss {
    init() {
        super.init(name: "Shadow Overlord",
                   atk: Int.random(in: 35...71),
                   specialAbility: .rainOfDeath,
                   specialAbilityName: "Rain of Death",
                   specialAbilityDescription: "Summons a rain of darkness that deals massive damage to all enemy units",
                   experienceGiven: 62,
                   maxHP: 440)
    }
}



let arrayOfSounds: [String] = ["argh", "achoo", "ahem", "bang", "bash", "bam", "bark", "bawl", "beep", "belch", "blab", "blare", "blurt", "boing", "boink", "bonk", "bong", "boo", "boo-hoo", "boom", "bow-wow", "brring", "bubble", "bump", "burp", "buzz", "cackle", "chatter", "cheep", "chirp", "chomp", "choo-choo", "chortle", "clang", "clash", "clank", "clap", "clack", "clatter", "click", "clink", "clip clop", "cluck", "clunk", "cock a doodle doo", "cough", "crack", "crackle", "crash", "creak", "croak", "crunch", "cuckoo", "ding", "ding dong", "drip", "fizz", "flick", "flip", "flip-flop", "flop", "flutter", "giggle", "glug", "glup", "groan", "growl", "grunt", "guffaw", "gurgle", "hack", "haha", "hack", "hiccup", "hiss", "hohoho", "honk", "hoot", "howl", "huh", "hum", "jangle", "jingle", "ker-ching", "kerplunk", "knock", "la", "Lub Dub", "meow", "moan", "moo", "mumble", "munch", "murmur", "mutter", "neigh", "oink", "ouch", "ooze", "phew", "ping", "ping pong", "pitter patter", "plink", "plop", "pluck", "plunk", "poof", "pong", "pop", "pow", "purr", "quack", "rattle", "ribbit", "ring", "rip", "roar", "rumble", "rush", "rustle", "screech", "shuffle", "shush", "sizzle", "slap", "slash", "slish", "slither", "slosh", "slurp", "smack", "snap", "snarl", "sniff", "snip", "snore", "snort", "spit", "splash", "splat", "splatter", "splish", "splosh", "squawk", "squeak", "squelch", "squish", "sway", "swish", "swoosh", "thud", "thump", "thwack", "tic-toc", "tinkle", "trickle", "twang", "tweet", "ugh", "vroom", "waffle", "whack", "whallop", "wham", "whimper", "whip", "whirr", "whish", "whisper", "whizz", "whoop", "whoosh", "woof", "yelp", "yikes", "zap", "zing", "zip", "zoom"]
