//
//  MemoryGame.swift
//  Memorize
//
//  Created by CS193p Instructor on 4/5/21.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable
{
    //A memory game has a set of cards, a score, and an index for the first chosen card (sometimes)
        private(set) var cards: Array<Card>
        private(set) var score = 0
        private var indexOfFirstChosenCard: Int?
        {
            get {cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly}
            set {cards.indices.forEach{cards[$0].isFaceUp = $0 == newValue}}
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
                //if this is the second cad chosen
                if let potentialMatchIndex = indexOfFirstChosenCard
                {
                    //Update 'number of times seen' for both cards
                    cards[chosenIndex].timesSeen += 1
                    cards[potentialMatchIndex].timesSeen += 1
                    //If the cards match
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content
                    {
                        //set both cards to matched and add to score
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2
                    }
                    //if cards don't match, but either has been seen before
                    else if cards[chosenIndex].timesSeen > 1 ||
                                cards[potentialMatchIndex].timesSeen > 1
                    //Subtract from score
                    {score -= 1}
                    //Toggle card to flip over
                    self.cards[chosenIndex].isFaceUp = true
                }
                //if this is the first card chosen
                else
                {
                    //set the index of the first chosen card
                    indexOfFirstChosenCard = chosenIndex
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
                
                cards.append(Card(content: content, id: pairIndex*2))
                cards.append(Card(content: content, id: pairIndex*2+1))
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
            var id: Int
            var timesSeen = 0
        
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

//an extension to Array, exists if an array contains only one element, is that element
extension Array
{
    var oneAndOnly: Element?
    {
        if(self.count == 1)
        {return self.first}
        else
        {return nil}
    }
}
