//
// Cards For Alan
// Created by Skyler Hope on Feb 17
//

import UIKit
import Foundation

// MARK: Enums 'n such
enum Suit {
    case spades, clubs, hearts, diamonds
}

enum PlayingCardValue: Int {
    case one = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
}

struct Card {
    var value: PlayingCardValue
    var suit: Suit
}
enum BackwardsHandType: Int {
    case royalFlush = 1
    case straightFlush
    case fourOfAKind
    case fullHouse
    case flush
    case straight
    case threeOfAKind
    case twoPair
    case onePair
    case highCard
}
enum HandType: Int {
    case highCard = 1
    case onePair = 2
    case twoPair = 3
    case threeOfAKind = 4
    case straight = 5
    case flush = 6
    case fullHouse = 7
    case fourOfAKind = 8
    case straightFlush = 9
    case royalFlush = 10
}

struct Hand {
    let cards: [Card]
    var handType: HandType // Bonus points for changing from a string to a custom enum of all the winningHands
    
    init(_ cards: [Card]) {
        self.cards = cards
        self.handType = .highCard // initialize the handType property to some default value
        self.handType = determineHandType(hand: self)
    }
    
        // MARK: determineHAndType()
    func determineHandType(hand: Hand) -> HandType {
            // A Set can only have unique values, so if this array of the suits in the hand is equal to one, we have a flush.
        let isFlush = Set(hand.cards.map { $0.suit }).count == 1
        
            // If the count in unique values is less than 5, then there are duplicates in the hand, which means we dont have a straight
            // In every straight, the difference of the highest and lowest values is always equal to four. These two facts combined indicate that we have a straight.
        let sortedValues = hand.cards.map { $0.value.rawValue }.sorted()
        let uniqueValues = Set(sortedValues)
        let isStraight = sortedValues.last! - sortedValues.first! == 4 && uniqueValues.count == 5
            
            // Because the cards are sorted by value, we know that if the value of the last card is 14, or Ace, then we have a royal flush. We start with royal flush and go down so the function will return the highest handType of the hand.
        if isFlush && isStraight && sortedValues.last! == PlayingCardValue.ace.rawValue {
            return .royalFlush
        } else if isFlush && isStraight {
            return .straightFlush
            
            // If there are two unique values, we know its either a four of a kind or a full house.
        } else if uniqueValues.count == 2 {
            
                // When we group the cards based on their value, if one of the groups have four cards, then its a four of a kind. Otherwise, it will be a full house.
            let valueCounts = Dictionary(grouping: sortedValues, by: { $0 }).mapValues { $0.count }
            if valueCounts.values.contains(4) {
                return .fourOfAKind
            } else {
                return .fullHouse
            }
            
        } else if isFlush {
            return .flush
        } else if isStraight {
            return .straight
            
            // if there are three unique values, we either have a three of a kind or two pair.
        } else if uniqueValues.count == 3 {
            
                // if there are three of one value in one group, it has to be a three of a kind. Otherwise, it has to be a two pair.
            let valueCounts = Dictionary(grouping: sortedValues, by: { $0 }).mapValues { $0.count }
            if valueCounts.values.contains(3) {
                return .threeOfAKind
            } else {
                return .twoPair
            }
            
        } else if uniqueValues.count == 4 {
            return .onePair
        } else {
            return .highCard
        }
    }
}


// MARK: determineWinner()
func determineWinner(_ hands: [Hand]) -> Hand? {
    
    guard !hands.isEmpty else {
        return nil
    }
    
        // initialize the variable winningHand to be the first element in the [Hands] paramter passed to the function
    var winningHand: Hand? = hands.first
    
        // using dropFirst() loop through all of the elements except for the first one, allowing comparison between the first one and the others
    for hand in hands.dropFirst() {
            // transfer the value of winningHand to a new variable so we dont lose track of it
        if let currentWinningHand = winningHand {
                // compare the values of each handtype and set the winner
            if hand.handType.rawValue > currentWinningHand.handType.rawValue {
                winningHand = hand
                
                // if the handType values are equal, test the values of the cards for the winner
            } else if hand.handType.rawValue == currentWinningHand.handType.rawValue {
                    // sort the values so that they are compared from highest to lowest
                let handValues = hand.cards.map { $0.value.rawValue }.sorted().reversed()
                let currentWinningHandValues = currentWinningHand.cards.map { $0.value.rawValue }.sorted().reversed()
                
                    // assign the winner
                for (value1, value2) in zip(handValues, currentWinningHandValues) {
                    if value1 > value2 {
                        winningHand = hand
                        break
                    } else if value2 > value1 {
                        break
                    }
                }
            }
        } else {
            winningHand = hand
        }
    }
    
    return winningHand
}

//MARK: Testing determineHandType()
let royalFlush = [
    Card(value: .ten, suit: .spades),
    Card(value: .jack, suit: .spades),
    Card(value: .queen, suit: .spades),
    Card(value: .king, suit: .spades),
    Card(value: .ace, suit: .spades)
]

let royalFlushTestHand = Hand(royalFlush)
print(royalFlushTestHand.handType)

let straightFlush = Hand([
    Card(value: .nine, suit: .hearts),
    Card(value: .eight, suit: .hearts),
    Card(value: .seven, suit: .hearts),
    Card(value: .six, suit: .hearts),
    Card(value: .five, suit: .hearts)
])
print(straightFlush.handType)

let fourOfAKind = Hand([
    Card(value: .jack, suit: .hearts),
    Card(value: .jack, suit: .diamonds),
    Card(value: .jack, suit: .clubs),
    Card(value: .jack, suit: .spades),
    Card(value: .king, suit: .hearts)
])
print(fourOfAKind.handType)

let fullHouse = Hand([
    Card(value: .ace, suit: .hearts),
    Card(value: .ace, suit: .diamonds),
    Card(value: .ace, suit: .clubs),
    Card(value: .queen, suit: .hearts),
    Card(value: .queen, suit: .spades)
])
print(fullHouse.handType)

let flush = Hand([
    Card(value: .ace, suit: .diamonds),
    Card(value: .king, suit: .diamonds),
    Card(value: .jack, suit: .diamonds),
    Card(value: .nine, suit: .diamonds),
    Card(value: .five, suit: .diamonds)
])
print(flush.handType)

let straight = Hand([
    Card(value: .ten, suit: .hearts),
    Card(value: .nine, suit: .spades),
    Card(value: .eight, suit: .diamonds),
    Card(value: .seven, suit: .hearts),
    Card(value: .six, suit: .clubs)
])
print(straight.handType)

let threeOfAKind = Hand([
    Card(value: .queen, suit: .spades),
    Card(value: .queen, suit: .hearts),
    Card(value: .queen, suit: .diamonds),
    Card(value: .ace, suit: .clubs),
    Card(value: .king, suit: .hearts)
])
print(threeOfAKind.handType)

let twoPair = Hand([
    Card(value: .ace, suit: .spades),
    Card(value: .ace, suit: .diamonds),
    Card(value: .king, suit: .clubs),
    Card(value: .king, suit: .hearts),
    Card(value: .queen, suit: .spades)
])
print(twoPair.handType)

let onePair: Hand = Hand([
    Card(value: .ace, suit: .diamonds),
    Card(value: .ace, suit: .clubs),
    Card(value: .king, suit: .diamonds),
    Card(value: .queen, suit: .hearts),
    Card(value: .jack, suit: .spades)
])
print(onePair.handType)

let highCard: Hand = Hand([
    Card(value: .ace, suit: .diamonds),
    Card(value: .king, suit: .clubs),
    Card(value: .queen, suit: .diamonds),
    Card(value: .jack, suit: .hearts),
    Card(value: .nine, suit: .spades)
])
print(highCard.handType)


//MARK: Testing determineWinner

let winner0 = determineWinner([onePair, twoPair])
print("winner: \(winner0!.handType)")

let winner1 = determineWinner([onePair, twoPair, threeOfAKind, straight])
print("winner: \(winner1!.handType)")

let winner2 = determineWinner([onePair, twoPair, threeOfAKind, straight, flush, fullHouse])
print("winner: \(winner2!.handType)")

let winner3 = determineWinner([onePair, twoPair, threeOfAKind, straight, flush, fullHouse, fourOfAKind, straightFlush])
print("winner: \(winner3!.handType)")

let winner4 = determineWinner([onePair, twoPair, threeOfAKind, straight, flush, fullHouse, fourOfAKind, straightFlush, royalFlushTestHand])
print("winner: \(winner4!.handType)")

