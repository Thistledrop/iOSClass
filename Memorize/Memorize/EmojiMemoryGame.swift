//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Hailey Carter on 1/28/22.
//
import SwiftUI

class EmojiMemoryGame: ObservableObject
{
    @Published private var model: MemoryGame<String>
    private(set) var theme: Theme
    
    typealias Card = MemoryGame<String>.Card
    
    //initializes the Emoji Memory Game with a random theme
    init(theme: Theme? = nil)
    {
        self.theme = theme ?? Theme.themes.randomElement()!
        self.model = Self.createMemoryGame(self.theme)
    }
    
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
    
    var cards: Array<Card>
    { model.cards }
    
    var score: Int
    { model.score }
    
    var color: SwiftUI.Color
    { theme.color }
    
    func choose(_ card: Card)
    { model.choose(card: card) }
    
    func restart()
    { self.model = Self.createMemoryGame(self.theme) }
    
    func shuffle()
    { model.shuffle() }
}
