//
//  ThemesView.swift
//  MyNotes
//
//  Created by apple on 27.01.2025.
//

import SwiftUI

import SwiftUI

struct ThemesView: View {
    let themes: [Theme] = [
        Theme(name: "Winter", background: "WinterBackground", accentColor: .blue),
        Theme(name: "Autumn", background: "AutumnBackground", accentColor: .orange),
        Theme(name: "Summer", background: "SummerBackground", accentColor: .yellow)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
//                Text("Themes")
//                    .font(.largeTitle)
//                    .bold()
                
                TabView {
                    ForEach(themes) { theme in
                        ThemeCard(theme: theme)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 400)
                
                Button(action: {
                    print("Get it button tapped")
                }) {
                    Text("Get it")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Themes")
        }
    }
}

struct ThemeCard: View {
    let theme: Theme
    
    var body: some View {
        ZStack {
            Image(theme.background)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 400) // Adjusted width and height
                .clipped()
                .cornerRadius(20)
                .shadow(radius: 5)
            
            VStack {
                Text(theme.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(theme.accentColor)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct Theme: Identifiable {
    let id = UUID()
    let name: String
    let background: String
    let accentColor: Color
}

struct ThemesView_Previews: PreviewProvider {
    static var previews: some View {
        ThemesView()
    }
}
#Preview {
    ThemesView()
}
