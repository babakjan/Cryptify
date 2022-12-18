//
//  SettingsView.swift
//  Cryptify
//
//  Created by Jan Babák on 28.11.2022.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingViewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            settingsSection
            
            aboutSection
        }
        .navigationTitle(LocalizedStringKey("settings"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                ToolbarHeaderView(icon: "xmark", iconAction: { self.dismiss() })
            }
        }
    }
    
    private var settingsSection: some View {
        Section(header: Text(LocalizedStringKey("settings"))) {
            themePicker
            
            notificationsToggle
            
            soundEffectsToggle
            
            defaultMarketsListPicker
            
            resetBtn
        }
    }
    
    private var aboutSection: some View {
        Section(header: Text(LocalizedStringKey("about"))) {
            Label(LocalizedStringKey("sourceCode"), systemImage: "link")
            Label(LocalizedStringKey("followMeOnGitHub"), systemImage: "person")
            Label(LocalizedStringKey("messageMeOnLinkedIn"), systemImage: "paperplane")
        }
    }
    
    private var themePicker: some View {
        Picker(selection: settingViewModel.$colorScheme) {
            ForEach(Theme.allCases) { theme in
                Text(LocalizedStringKey(theme.rawValue))
                    .tag(theme)
            }
        } label: {
            Label(LocalizedStringKey("theme"), systemImage: settingViewModel.colorScheme == .dark ? "moon" :
                    settingViewModel.colorScheme == .light ? "sun.max" : "apps.iphone")
        }.onChange(of: settingViewModel.colorScheme) { newValue in
            SoundManager.shared.playTab()
        }
    }
    
    private var defaultMarketsListPicker: some View {
        Picker(selection: $settingViewModel.defaultMarketsList) {
            ForEach(settingViewModel.listNames, id: \.self) { listName in
                Text(listName)
            }
        } label: {
            Label(LocalizedStringKey("defaultMarketList"), systemImage: "list.bullet")
        }.onChange(of: settingViewModel.defaultMarketsList) { newValue in
            SoundManager.shared.playTab()
        }
    }
    
    private var notificationsToggle: some View {
        Toggle(isOn: settingViewModel.$notificationsOn) {
            Label(LocalizedStringKey("notifications"), systemImage: settingViewModel.notificationsOn ? "bell.badge" : "bell.slash")
        }.onChange(of: settingViewModel.notificationsOn) { newValue in
            SoundManager.shared.playTab()
            NotificationManager.shared.notificatiosOnToggled()
        }
    }
    
    private var soundEffectsToggle: some View {
        Toggle(isOn: settingViewModel.$soundOn) {
            Label(LocalizedStringKey("soundEffects"), systemImage: settingViewModel.soundOn ? "speaker.wave.2" : "speaker.slash")
        }.onChange(of: settingViewModel.soundOn) { newValue in
            SoundManager.shared.playTab()
        }
    }
    
    private var resetBtn: some View {
        Button {
            SoundManager.shared.playTab()
            settingViewModel.resetAllSettings()
        } label: {
            Label(LocalizedStringKey("resetAllSettings"), systemImage: "arrow.counterclockwise")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
