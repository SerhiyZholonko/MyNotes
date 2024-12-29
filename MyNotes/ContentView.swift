//
//  ContentView.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext  // Access modelContext

    var body: some View {
        MainTabView()
            .modelContainer(for: [NoteModel.self, TagModel.self])
            .onAppear {
                if let storeURL = getPersistentStoreURL() {
                    print("Store URL: \(storeURL)")
                } else {
                    print("Unable to find the store URL.")
                }
            }
    }
    
    func getPersistentStoreURL() -> URL? {
        do {
            let fileManager = FileManager.default
            let applicationSupportDirectory = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let storeURL = applicationSupportDirectory.appendingPathComponent("Model.sqlite") // Default SQLite filename
            return storeURL
        } catch {
            print("Error finding application support directory: \(error)")
            return nil
        }
    }
}
#Preview {
    ContentView()
}


