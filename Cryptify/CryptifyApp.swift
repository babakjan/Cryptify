//
//  CryptifyApp.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import SwiftUI

@main
struct CryptifyApp: App {
    
    @AppStorage(SettingsViewModel.colorSchemeUserDefaultsKey) private var colorScheme = Theme.system
    
    init() {
        //set text color of buttons in alerts to accent
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color.theme.accent)
        //set preffered color scheme to alerts
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).overrideUserInterfaceStyle =
        colorScheme == Theme.light ? .light : colorScheme == Theme.dark ? .dark : .unspecified
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(colorScheme == Theme.light ? .light : colorScheme == Theme.dark ? .dark : .none)
        }
    }
}
