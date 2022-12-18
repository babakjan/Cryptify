//
//  SettingsViewModel.swift
//  Cryptify
//
//  Created by Jan Babák on 01.12.2022.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage(SettingsViewModel.colorSchemeUserDefaultsKey) var colorScheme = Theme.system
    @AppStorage(SoundManager.soundOnUserDefaultsKey) var soundOn = false
    @AppStorage(NotificationManager.notificationsOnUserDefaultsKey) var notificationsOn = true
    @AppStorage(MarketsViewModel.defaultMarketListUserDefaultsKey) var defaultMarketsList = SpecialMarketsList.all.rawValue
    
    static let colorSchemeUserDefaultsKey = "colorScheme"
    
    @MainActor
    func resetAllSettings() {
        colorScheme = Theme.system
        soundOn = false
        notificationsOn = true
        defaultMarketsList = SpecialMarketsList.all.rawValue
    }
    
    //names of all market lists available
    var listNames: [String] {
        let marketLists = MarketsViewModel.loadMarketListsFromUserDefauls()
        return [SpecialMarketsList.all.rawValue] + marketLists.keys.sorted(by: >)
    }
}
