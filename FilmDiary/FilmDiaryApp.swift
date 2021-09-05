//
//  FilmDiaryApp.swift
//  FilmDiary
//
//  Created by Brendan Goldsmith on 9/3/21.
//

import SwiftUI

@main
struct FilmDiaryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
