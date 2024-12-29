//
//  File.swift
//  MyNotes
//
//  Created by apple on 21.12.2024.
//

import Foundation
import SwiftData

@Model
class EnergyItem: Identifiable {
    var id = UUID()  // Add unique identifier
    var color: String?
    var name: String
    var sfSymbol: String
    init(color: String?, name: String, sfSymbol: String) {
        self.color = color
        self.name = name
        self.sfSymbol = sfSymbol
    }
    
}
