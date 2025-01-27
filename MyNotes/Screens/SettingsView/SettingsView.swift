//
//  SettingsView.swift
//  MyNotes
//
//  Created by apple on 27.01.2025.
//

import SwiftUI


struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("General Settings")) {
                    Toggle("Sync iCloud (Auto)", isOn: .constant(false))
                    Button("Clear All Data") {
                        // Action for clearing data
                    }
                    Toggle("Enable Password", isOn: .constant(false))
                    NavigationLink("Themes") {
                        ThemesView()
                    }
                }
                
                Section(header: Text("Support")) {
                    NavigationLink("Support Page") {
                        SupportPageView()
                    }
                    NavigationLink("Feedback & Review") {
                        FeedbackView()
                    }
                    Button("Share App") {
                        // Action for sharing app
                    }
                    NavigationLink("Privacy Policy") {
                        PrivacyPolicyView()
                    }
                }
            }
            .navigationTitle("Settings")
            .listStyle(InsetGroupedListStyle())
        }
    }
}
// Placeholder views for navigation links


struct SupportPageView: View {
    var body: some View {
        Text("Support Page")
            .navigationTitle("Support")
    }
}

struct FeedbackView: View {
    var body: some View {
        Text("Feedback & Review")
            .navigationTitle("Feedback")
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        Text("Privacy Policy")
            .navigationTitle("Privacy Policy")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
