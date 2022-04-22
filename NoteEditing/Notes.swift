//
//  Notes.swift
//
//  Created by Hailey Carter & Antonio Marroquin
//
import Foundation
import SwiftUI


//A temporary Struct to represent a note that can be stored,
//contains a temporary array of test notes and a 'new note' created when User creates a new note
struct Note: Codable, Identifiable
{
    var id: String { title }
    
    var title : String
    var content : String
    
    init(title: String, content: String)
    {
        self.title = title
        self.content = content
    }
    
    var json: Data?
        { try? JSONEncoder().encode(self) }
    
    init?(json: Data?)
    {
        if let json = json, let Note = try? JSONDecoder().decode(Note.self, from: json)
        { self = Note  }
        else { return nil }
    }
    
    //Testing notes
    static var notes: [Note] = [
        Note(title: "Test Note 1",content: "This note is a test"),
        Note(title: "Test Note 2",content: "This note is a test"),
        Note(title: "Test Note 3",content: "This note is a test")
    ]
    //'new' note - Do Not Remove!
    static let test = Note(title: "New Note",content: "...")
}
