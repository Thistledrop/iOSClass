//
//  NoteEditorView.swift
//
//  Created by Hailey Carter & Antonio Marroquin
//

import SwiftUI

//Editing page for notes, accessed through the home page
//Allows for editing of the title and content of any note
struct NoteEditor: View
{
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: NoteStore
    let note: Note
    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View
    {
        NavigationView
        {
            Form
            {
                TitleSection
                ContentSection
            }
            .onAppear()
            {
                self.title = self.note.title
                self.content = self.note.content
            }
            .navigationBarTitle(Text("Note Editor"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: cancel, label: { Text("Cancel") }),
                trailing: Button(action: saveTheme, label: { Text("Done") })
                    .disabled(cannotSave)
            )
        }
    }

    var TitleSection: some View
    {
        Section(header: Text("Title:").font(.headline))
        { TextEditor(text: $title) }
    }
    
    var ContentSection: some View
    {
        Section(header: Text("Content:").font(.headline))
        {
            TextEditor(text: $content)
                .frame(minHeight: 300, alignment: .leading)
        }
    }

    //Saving or not saving a theme
    private var cannotSave: Bool
    {  title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    private func saveTheme()
    {
        title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        store.updateTheme(for: note, title: title, content: content)
        presentationMode.wrappedValue.dismiss()
    }

    private func cancel()
    { presentationMode.wrappedValue.dismiss() }
}

struct EmojiMemoryThemeEditor_Previews: PreviewProvider
{
    static var previews: some View
    { NoteEditor(note: .test) }
}
