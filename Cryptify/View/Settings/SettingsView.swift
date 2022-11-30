//
//  SettingsView.swift
//  Cryptify
//
//  Created by Jan Babák on 28.11.2022.
//

import SwiftUI

struct SettingsView: View {
//    @Binding var navigationPath: [Symbol]
    @Environment(\.dismiss) private var dismiss
    @State var textFieldValue = ""
    @State var notificationsOn = true
    @State var soundEffects = false
    @State var theme = "dark"
    var themes = ["dark", "light", "system"]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Form {
            Picker(selection: $theme, label: Text("Theme")) {
                ForEach(themes, id: \.self) { theme in
                    Text(theme)
                }
            }
            .onChange(of: theme, perform: chooseTheme)
            
            Toggle(isOn: $notificationsOn) {
                Text("Notifications")
            }
            
            Toggle(isOn: $soundEffects) {
                Text("Sound effects")
            }
            
            Button(action: {}) {
                Text("Rest All Settings")
            }
            
        }
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                ToolbarHeaderView(icon: "xmark", iconAction: { self.dismiss() })
            }
        }
    }
    
    func chooseTheme(newValue: String) {
        print("theme:", newValue, theme)
//        switch newValue {
//        case "light": colorScheme = .light
//        case "dark": colorScheme = .dark
//        case "system": colorScheme = .allCases
//        default: return
//        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
