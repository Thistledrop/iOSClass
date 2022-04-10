//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Hailey Carter on 1/28/22.
//
import SwiftUI

class EmojiMemoryGame: ObservableObject
{
    typealias Card = MemoryGame<String>.Card
    
    //creates a memory game with emojis
    static func createMemoryGame(_ GameTheme: Theme) -> MemoryGame<String>
    {
        //get emojis from the given theme, shuffles them, then picks the ones that will appear as pairs
        //and stores them as cards to show
        let emojis: Array<String> = GameTheme.contents.shuffled()
        var cardsToShow : Int
        
        //EC: If the pairCount from the theme is zero, get a random number of cards to show
        if(GameTheme.pairCount != 0)
        {cardsToShow = GameTheme.pairCount}
        else
        {cardsToShow = Int.random(in: 4..<GameTheme.contents.count)}
        
        if cardsToShow > GameTheme.contents.count {
            cardsToShow = GameTheme.contents.count
        }
        
        return MemoryGame<String>(numOfPairs: cardsToShow)
        {index in emojis[index]}
    }
    
    func restart()
    {
        self.model = Self.createMemoryGame(self.theme)
    }
    
    func shuffle()
    { model.shuffle() }
    
    //initializes the Emoji Memory Game with a random theme
    init(theme: Theme = Theme.themes.randomElement()!)
    {
        self.theme = theme
        self.model = Self.createMemoryGame(theme)
    }
    
    @Published private var model: MemoryGame<String>
    var theme: Theme
    
    var cards: Array<Card>
    {model.cards}
    
    var score: Int
    {model.score}
    
    //Takes the 'color' string from a theme and returns a Swift UI Color
    var color: SwiftUI.Color
    { theme.color }
    
    func choose(_ card: Card)
    {model.choose(card: card)}
}
