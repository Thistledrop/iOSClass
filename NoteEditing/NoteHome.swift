//
//  NoteHome.swift
//
//  Created by Hailey Carter & Antonio Marroquin
//

import SwiftUI

//Home page for notes, displays all notes and allows for editing, adding, and deleting
struct NoteHome: View
{
    @EnvironmentObject var store: NoteStore
    @State private var editMode: EditMode = .inactive
    @State private var showNoteEditor = false
    @State private var editingNote: Note?
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(store.notes){ note in
                    ZStack
                    {
                        NoteRow(store: store, note: note)
                        { self.editingNote = note }
                    }
                }
                .onDelete { indexSet in self.store.notes.remove(atOffsets: indexSet) }
            }
            .sheet(item: self.$editingNote, content: { note in
                NoteEditor(note: note)
                    .environmentObject(self.store)
            })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Notes")
        .navigationBarItems(
            leading: Text(" "),
            trailing: Button(action: { self.store.notes.append(Note.test) },
                            label: { Image(systemName: "plus").imageScale(.large) }))
        .environment(\.editMode, $editMode)
        }
    }
}

//Row that displays and allows interaction with a note
struct NoteRow: View
{
    var store: NoteStore
    let note: Note
    let editNote: ()->Void
    
    var body: some View
    {
        HStack
        {
            VStack(alignment: .leading)
            {
                Text(note.title)
                    .font(.title)
                    .foregroundColor(.black)
            }
            Spacer()
            Button(action: editNote)
            {
                Image(systemName: "pencil.circle.fill")
                    .imageScale(.large)
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.red)
            
            Spacer()
            
            Button(action: deleteNote)
            {
                Image(systemName: "trash.circle.fill")
                    .imageScale(.large)
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.red)
        }
        .padding()
    }
    func deleteNote()
    { store.notes.remove(at: store.notes.firstIndex(matching: note)!) }
}

struct EmojiMemoryThemeChooser_Previews: PreviewProvider
{
    static var previews: some View
    { NoteHome().environmentObject(NoteStore()) }
}
