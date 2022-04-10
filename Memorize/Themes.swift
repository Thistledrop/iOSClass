//
//  Themes.swift
//  Memorize
//
//  Created by Hailey Carter on 2/8/22.
//
import Foundation
import SwiftUI

struct Theme: Codable, Identifiable
{
    //The standard themes the app comes with
    static var themes: [Theme] = [
        Theme(name: "Animals", contents: ["🐮", "🐷", "🐸", "🐔", "🐧", "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐝", "🦋", "🪲", "🐢", "🦭", "🦬", "🦌", "🐪", "🦏"], colorRGB: UIColor.systemOrange.rgb, pairCount: 8),
        Theme(name: "The Weather", contents: ["🌞", "🌝", "⭐️", "🌪", "🌈", "☀️", "⛅️", "☁️", "🌦", "🌧", "⛈", "🌨", "❄️", "💨", "💧", "☔️"], colorRGB: UIColor.systemBlue.rgb, pairCount: 6),
        Theme(name: "Body Parts", contents: ["🧠", "🫁", "🫀", "👁", "🦵", "👃", "👂", "👅", "🦷", "👄", "💪"], colorRGB: UIColor.systemRed.rgb, pairCount: 5),
        Theme(name: "The Zodiac", contents: ["♌️", "♍️", "♏️", "♓️", "♉️", "♈️", "⛎", "♒️", "♋️", "♐️", "♊️", "♑️"], colorRGB: UIColor.systemPurple.rgb, UseAll: true),
        Theme(name: "The Garden", contents: ["🥦", "🍅", "🌶", "🌽", "🥕", "🥬", "🥒", "🧄", "🍆", "🧅", "🌷", "🌺", "🌹", "🌸", "🌼", "🌻", "💐"], colorRGB: UIColor.systemGreen.rgb, pairCount: 8),
        Theme(name: "Game Pieces", contents: ["♣︎", "♥︎", "♦︎", "♠︎", "♚", "♛", "♜", "♝", "♞", "♟", "⚄", "🂠", "🁋"], colorRGB: UIColor.systemGray.rgb, UseAll: false)
        ]
    
    static let template = Theme(name: "Untitled", contents: ["😃", "👍🏻", "🌈", "❤️"], colorRGB: UIColor.systemGreen.rgb, pairCount: 4)
    
    var id: String { name }
    var name : String
    var contents : [String]
    let colorRGB: UIColor.RGB
    var pairCount : Int
    
    var color: Color
    { Color(colorRGB) }
    
    var json: Data?
    { try? JSONEncoder().encode(self) }
    
    //Initializer if a number of pairs is specified
    init(name: String, contents: [String], colorRGB: UIColor.RGB, pairCount: Int)
    {
        self.name = name
        self.contents = contents
        self.colorRGB = colorRGB
        self.pairCount = pairCount
    }
    
    //EC: initializer if a number of pairs is not specified, instead we ask if we want to use all the emojis or not
    init(name: String, contents: [String], colorRGB: UIColor.RGB, UseAll: Bool)
    {
        self.name = name
        self.contents = contents
        self.colorRGB = colorRGB
        
        //if we want to use all emojis, pairCount is set to the number of emojis in the content
        if(UseAll)
        {self.pairCount = contents.count}
        //If we don't want to use all the emojis, pairCount is set to zero, triggering an if statement in the creation of an emoji memory game that will determine a random number of pairs
        else
        {self.pairCount = 0}
    }
    
    init?(json: Data?)
    {
        if let json = json, let Theme = try? JSONDecoder().decode(Theme.self, from: json) {
            self = Theme
        }
        else {
            return nil
        }
    }
}
