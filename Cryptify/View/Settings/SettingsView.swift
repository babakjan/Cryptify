//
//  SettingsView.swift
//  Cryptify
//
//  Created by Jan Babák on 28.11.2022.
//

import SwiftUI

struct SettingsView: View {
    @Binding var navigationPath: NavigationPath
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Group {
            Text("Hello, World!, settings")
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
        SettingsView(navigationPath: .constant(NavigationPath()))
    }
}
