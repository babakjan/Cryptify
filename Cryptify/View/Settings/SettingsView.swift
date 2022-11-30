//
//  SettingsView.swift
//  Cryptify
//
//  Created by Jan Babák on 28.11.2022.
//

import SwiftUI

struct SettingsView: View {
    @State var textFieldValue = ""
    @State var notificationsOn = true
    @State var soundEffects = false
    @AppStorage("colorScheme") private var colorScheme: String = Theme.system
    var themes = [Theme.light, Theme.dark, Theme.system]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Picker(selection: $colorScheme, label: Text("Theme")) {
                ForEach(themes, id: \.self) {
                    Text($0)
                }
            }
            
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
