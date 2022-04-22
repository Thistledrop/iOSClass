//
//  NoteStorage.swift
//
//  Created by Hailey Carter & Antonio Marroquin
//

import UIKit
import Combine

//Permanent Storage of notes
class NoteStore: ObservableObject
{
    private var autosave: AnyCancellable?
    @Published var notes: [Note]

    init()
    {
        let defaultsKey = "EmojiMemoryThemeStore"
        notes = (UserDefaults.standard.object(forKey: defaultsKey) as? [Data])?
            .compactMap({ Note(json: $0) }) ?? Note.notes
        autosave = $notes.sink { notes in
            UserDefaults.standard.set(notes.map{$0.json}, forKey: defaultsKey)
        }
    }
    
    //Stores updated theme in storage
    func updateTheme(for note: Note, title: String, content: String)
    {
        let newTheme = Note(title: title, content: content)
        if let index = notes.firstIndex(matching: note)
        { notes[index] = newTheme }
    }
}

//Convienence Extensions of 'Array'
extension Array where Element: Identifiable
{
    // find the index of the first element matching the ID of the given item
    func firstIndex(matching item: Element) -> Int?
    {
        if let index = self.firstIndex(where: {item.id == $0.id})
        { return index }
        return nil
    }
}

extension Array
{
    // return the one and only element or nil
    var only: Element?
    { count == 1 ? first : nil }
}
