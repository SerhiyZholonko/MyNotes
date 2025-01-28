//
//  ContentView.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import SwiftUI
import SwiftData
import LocalAuthentication

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
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        // Check if the device supports Face ID
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to proceed") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Authentication successful
                        print("Authenticated successfully")
                    } else {
                        // Authentication failed
                        print("Authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        } else {
            // Device doesn't support Face ID
            print("Face ID is not available on this device.")
        }
    }
}
#Preview {
    ContentView()
}


