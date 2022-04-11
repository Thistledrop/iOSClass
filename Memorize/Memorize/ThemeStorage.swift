//
//  ThemeStorage.swift
//  Memorize
//
//  Created by Hailey Carter on 4/10/22.
//

import UIKit
import Combine

class EmojiMemoryThemeStore: ObservableObject {

    private var autosave: AnyCancellable?
    @Published var themes: [Theme]

    init() {
        let defaultsKey = "EmojiMemoryThemeStore"
        themes = (UserDefaults.standard.object(forKey: defaultsKey) as? [Data])?
            .compactMap({ Theme(json: $0) }) ?? Theme.themes
        autosave = $themes.sink { themes in
            UserDefaults.standard.set(themes.map{$0.json}, forKey: defaultsKey)
        }
    }

    func updateTheme(for theme: Theme, name: String, emoji: [String], colorRGB: UIColor.RGB, numberOfPairs: Int) {
        let newTheme = Theme(name: name, contents: emoji, colorRGB: colorRGB, pairCount: numberOfPairs)
        if let index = themes.firstIndex(matching: theme) {
            themes[index] = newTheme
        }
    }
}
