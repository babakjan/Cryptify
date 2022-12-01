//
//  SettingsViewModel.swift
//  Cryptify
//
//  Created by Jan Babák on 01.12.2022.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage("colorScheme") var colorScheme = Theme.system
    @AppStorage("soundOn") var soundOn = false
    @AppStorage("notificationsOn") var notificationsOn = true
    
    func resetAllSettings() {
        colorScheme = Theme.system
        soundOn = false
        notificationsOn = true
    }
}
