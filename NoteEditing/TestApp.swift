//
//  TestApp.swift
//
//  Created by Hailey Carter & Antonio Marroquin
//
import SwiftUI

@main
struct TestApp: App
{
    var body: some Scene
    {
        WindowGroup
        { NoteHome().environmentObject(NoteStore()) }
    }
}
