//
//  Color.swift
//  MyNotes
//
//  Created by apple on 21.12.2024.
//

import SwiftUI

extension Color {
    func toHex() -> String? {
        // Get UIColor from SwiftUI Color
        let uiColor = UIColor(self)
        // Convert UIColor to CGColor
        guard let components = uiColor.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    // Convert hex string to Color
    static func fromHex(_ hex: String) -> Color {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        return Color(red: red, green: green, blue: blue)
    }
}
