//
//  SettingsView.swift
//  MyNotes
//
//  Created by apple on 27.01.2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var isFaceId: Bool = UserDefaults.standard.bool(forKey: "isFaceId") // Load saved state
    @State private var showPasswordSheet = false
    @State private var showRemovePrompt = false // Bind to display the alert
//    @State private var password: String = ""
    @State private var clearDataAlertIsPresented: Bool = false
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("General Settings")) {
                    Toggle("Sync iCloud (Auto)", isOn: .constant(false))
                    Button("Clear All Data") {
                        // Action for clearing data
                    }
                    .onTapGesture {
                        clearDataAlertIsPresented = true
                    }
                    .alert(isPresented: $clearDataAlertIsPresented) {
                        Alert(
                            title: Text("Clear all data"),
                            message: Text("Are you sure you want to remove all data?"),
                            primaryButton: .destructive(Text("Remove")) {
                               //remove data here 
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    Toggle(isOn: $isFaceId) {
                        Label("FaceId", systemImage: "faceid")
                    }
                        .onChange(of: isFaceId) { _, newValue in
                            if newValue {
                                UserDefaults.standard.set(true, forKey: "isFaceId")

                            } else {
                                UserDefaults.standard.set(false, forKey: "isFaceId")

                            }
                        }
//                        .alert(isPresented: $showRemovePrompt) { // Attach the alert here
//                            Alert(
//                                title: Text("Remove Password"),
//                                message: Text("Are you sure you want to disable the password?"),
//                                primaryButton: .destructive(Text("Remove")) {
//                                    removePassword() // Clear password
//                                },
//                                secondaryButton: .cancel {
//                                    isPasswordEnabled = true // Revert toggle
//                                }
//                            )
//                        }
                    
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
//            .sheet(isPresented: $showPasswordSheet) {
//                PasswordSetupSheet(isPasswordEnabled: $isPasswordEnabled)
//            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Helper Functions
    func removePassword() {
        KeychainHelper.removePassword() // Clear password securely
        UserDefaults.standard.set(false, forKey: "isPasswordEnabled")
    }
}

// MARK: - Password Setup Sheet
//struct PasswordSetupSheet: View {
//    @Binding var isPasswordEnabled: Bool
//    @State private var password: String = ""
//    @State private var confirmPassword: String = ""
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Set Your Password")) {
//                    SecureField("Enter Password", text: $password)
//                    SecureField("Confirm Password", text: $confirmPassword)
//                }
//            }
//            .navigationTitle("Set Password")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        isPasswordEnabled = false // Revert toggle
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Save") {
//                        if password == confirmPassword && !password.isEmpty {
//                            savePassword(password)
//                            presentationMode.wrappedValue.dismiss()
//                        } else {
//                            // Handle mismatch or empty passwords
//                            isPasswordEnabled = false // Revert toggle
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    // MARK: - Save Password
//    func savePassword(_ password: String) {
//        KeychainHelper.savePassword(password) // Save to Keychain
//        UserDefaults.standard.set(true, forKey: "isPasswordEnabled")
//    }
//}

// MARK: - SecureFieldAlert
struct SecureFieldAlert {
    let title: String
    let placeholder: String
    let onSave: (String?) -> Void
}// Placeholder views for navigation links


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
import Security

struct KeychainHelper {
    static func savePassword(_ password: String) {
        let data = password.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "AppPassword",
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary) // Remove old item
        SecItemAdd(query as CFDictionary, nil)
    }

    static func removePassword() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "AppPassword"
        ]
        SecItemDelete(query as CFDictionary)
    }

    static func getPassword() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "AppPassword",
            kSecReturnData as String: true
        ]
        var data: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &data) == errSecSuccess {
            if let data = data as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
}
