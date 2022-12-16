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
    @AppStorage(MarketsViewModel.defaultMarketListUserDefaultsKey) var defaultMarketsList = SpecialMarketsList.all.rawValue
    
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
