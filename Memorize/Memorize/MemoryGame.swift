//
//  MemoryGame.swift
//  Memorize
//
//  Created by CS193p Instructor on 4/5/21.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable
{
    private(set) var cards: Array<Card>
    private(set) var score = 0
    private var seenCards = [Card]()
    private var firstCardTimestamp : TimeInterval = 0

    private var indexOfFirstChosenCard: Int?
    {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set
        {
            for index in cards.indices
            {
                if cards[index].isFaceUp
                { seenCards.append(cards[index]) }
                cards[index].isFaceUp = index == newValue
            }
        }
    }

    mutating func shuffle()
    { cards.shuffle() }
    
    //This function 'chooses' a card, called when a card is tapped on
    //Most of the game functionality, matching, scoring, ect. is here
    mutating func choose(card: Card)
    {
        //if the first face up card in cards array is not face up or already matched...
        if let chosenIndex: Int = cards.firstIndex(where: { card.id == $0.id }), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched
        {
            //if this is the second card chosen
            if let potentialMatchIndex = indexOfFirstChosenCard, potentialMatchIndex != chosenIndex
            {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content
                {
                    //set both cards to matched and add to score
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    let currentCardTimestamp = Date().timeIntervalSinceReferenceDate
                    let multiplier = max(5 - (currentCardTimestamp - firstCardTimestamp), 1)
                    score += Int(2 * multiplier)
                }
                else {
                    score += seenCards.firstIndex(matching: cards[potentialMatchIndex]) != nil ? -1 : 0
                    score += seenCards.firstIndex(matching: cards[chosenIndex]) != nil ? -1 : 0
                }
                
                cards[chosenIndex].isFaceUp = true
            }
            else
            {
                indexOfFirstChosenCard = chosenIndex
                firstCardTimestamp = Date().timeIntervalSinceReferenceDate
            }
        }
    }
    
    //initializer: creates a memory game with a certain number of pairs and certain card content
    init(numOfPairs: Int, getCardContent: (Int) -> CardContent)
    {
        cards = []
        
        //add numOfPairs x2 cards to array
        for pairIndex in 0..<numOfPairs
        {
            let content = getCardContent(pairIndex)
            
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
        
        //shuffle cards before the game begins
        cards.shuffle()
    }
    
    //A struct for the cards of a memory game, basically a colection of variables
    struct Card: Identifiable
    {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id = UUID()
    
        // MARK: - Bonus Time
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval
        {
            if let lastFaceUpDate = self.lastFaceUpDate
            { return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate) }
            else { return pastFaceUpTime }
        }
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval
        { max(0, bonusTimeLimit - faceUpTime) }
        
        var bonusRemaining: Double
        { (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0 }
        
        var hasEarnedBonus: Bool
        { isMatched && bonusTimeRemaining > 0 }
        
        var isConsumingBonusTime: Bool
        { isFaceUp && !isMatched && bonusTimeRemaining > 0 }
            
        private mutating func startUsingBonusTime()
        {
            if isConsumingBonusTime, lastFaceUpDate == nil
            { lastFaceUpDate = Date() }
        }
            
        private mutating func stopUsingBonusTime()
        {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
