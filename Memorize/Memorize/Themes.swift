//
//  Themes.swift
//  Memorize
//
//  Created by Hailey Carter on 2/8/22.
//
import Foundation

struct Theme
{
    //The standard themes the app comes with
    static var themes: [Theme] = [
        Theme(name: "Animals", contents: ["🐮", "🐷", "🐸", "🐔", "🐧", "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐝", "🦋", "🪲", "🐢", "🦭", "🦬", "🦌", "🐪", "🦏"], color: "orange", pairCount: 8),
        Theme(name: "The Weather", contents: ["🌞", "🌝", "⭐️", "🌪", "🌈", "☀️", "⛅️", "☁️", "🌦", "🌧", "⛈", "🌨", "❄️", "💨", "💧", "☔️"], color: "blue", pairCount: 6),
        Theme(name: "Body Parts", contents: ["🧠", "🫁", "🫀", "👁", "🦵", "👃", "👂", "👅", "🦷", "👄", "💪"], color: "red", pairCount: 5),
        Theme(name: "The Zodiac", contents: ["♌️", "♍️", "♏️", "♓️", "♉️", "♈️", "⛎", "♒️", "♋️", "♐️", "♊️", "♑️"], color: "purple", UseAll: true),
        Theme(name: "The Garden", contents: ["🥦", "🍅", "🌶", "🌽", "🥕", "🥬", "🥒", "🧄", "🍆", "🧅", "🌷", "🌺", "🌹", "🌸", "🌼", "🌻", "💐"], color: "green", pairCount: 8),
        Theme(name: "Game Pieces", contents: ["♣︎", "♥︎", "♦︎", "♠︎", "♚", "♛", "♜", "♝", "♞", "♟", "⚄", "🂠", "🁋"], color: "black", UseAll: false)
        ]
    
    var name : String
    var contents : [String]
    var color : String
    var pairCount : Int
    
    //Initializer if a number of pairs is specified
    init(name: String, contents: [String], color: String, pairCount: Int)
    {
        self.name = name
        self.contents = contents
        self.color = color
        self.pairCount = pairCount
    }
    
    //EC: initializer if a number of pairs is not specified, instead we ask if we want to use all the emojis or not
    init(name: String, contents: [String], color: String, UseAll: Bool)
    {
        self.name = name
        self.contents = contents
        self.color = color
        
        //if we want to use all emojis, pairCount is set to the number of emojis in the content
        if(UseAll)
        {self.pairCount = contents.count}
        //If we don't want to use all the emojis, pairCount is set to zero, triggering an if statement in the creation of an emoji memory game that will determine a random number of pairs
        else
        {self.pairCount = 0}
    }
}
