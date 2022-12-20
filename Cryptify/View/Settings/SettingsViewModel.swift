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
    
    //names of all market lists available
    var listNames: [String] {
        let marketLists = MarketsViewModel.loadMarketListsFromUserDefauls()
        return [SpecialMarketsList.all.rawValue] + marketLists.keys.sorted(by: >)
    }
    
    @MainActor
    func resetAllSettings() {
        colorScheme = Theme.system
        soundOn = false
        notificationsOn = true
        defaultMarketsList = SpecialMarketsList.all.rawValue
    }
    
    //this function is required, color scheme of alerts wouldn't work without this
    func setColorTheme() {
        SoundManager.shared.playTab()
        
        //set preffered color scheme to alerts
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).overrideUserInterfaceStyle =
            colorScheme == Theme.light ? .light : colorScheme == Theme.dark ? .dark : .unspecified
    }
}
