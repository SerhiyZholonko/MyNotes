//
//  MainTabViewModel.swift
//  MyNotes
//
//  Created by apple on 01.12.2024.
//

import Foundation

class MainTabViewModel: ObservableObject {
    @Published var selectedTab = "3"

    @Published var isPressed1 = false // State for the first button
    @Published var isPressed2 = false // State for the second button
    @Published var isPressed3 = false // State for the third button
}
