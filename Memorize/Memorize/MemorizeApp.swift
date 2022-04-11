//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Hailey Carter on 1/12/22.
//
import SwiftUI

@main
struct MemorizeApp: App {
    //Creates a new memory game
//    let game = EmojiMemoryGame()
    @StateObject var store = EmojiMemoryThemeStore()   //creates a new view with said memory game
    var body: some Scene {
        WindowGroup {
            ThemeChooser()
                .environmentObject(store)
        }
    }
}
