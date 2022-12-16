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
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                ToolbarHeaderView(icon: "xmark", iconAction: { self.dismiss() })
            }
        }
    }
    
    private var settingsSection: some View {
        Section(header: Text("Settings")) {
            themePicker
            
            notificationsToggle
            
            soundEffectsToggle
            
            defaultMarketsListPicker
            
            resetBtn
        }
    }
    
    private var aboutSection: some View {
        Section(header: Text("About")) {
            Label("[Source code](https://gitlab.fit.cvut.cz/babakjan/cryptify)", systemImage: "link")
            Label("[Follow me on GitHub](https://github.com/babakjan)", systemImage: "person")
            Label("[Message me on LinkedIn](https://www.linkedin.com/in/janbabak/)", systemImage: "paperplane")
        }
    }
    
    private var themePicker: some View {
        Picker(selection: settingViewModel.$colorScheme) {
            ForEach(Theme.allCases) { theme in
                Text(theme.rawValue)
                    .tag(theme)
            }
        } label: {
            labelWithIcon(
                text: "Theme",
                systemImage: settingViewModel.colorScheme == .dark ? "moon" :
                    settingViewModel.colorScheme == .light ? "sun.max" : "apps.iphone"
            )
        }.onChange(of: settingViewModel.colorScheme) { newValue in
            SoundManager.instance.playTab()
        }
    }
    
    private var defaultMarketsListPicker: some View {
        Picker(selection: $settingViewModel.defaultMarketsList) {
            ForEach(settingViewModel.listNames, id: \.self) { listName in
                Text(listName)
            }
        } label: {
            labelWithIcon(text: "Default Markets list", systemImage: "list.bullet")
        }.onChange(of: settingViewModel.defaultMarketsList) { newValue in
            SoundManager.instance.playTab()
        }
    }
    
    private var notificationsToggle: some View {
        Toggle(isOn: settingViewModel.$notificationsOn) {
            labelWithIcon(
                text: "Notifications",
                systemImage: settingViewModel.notificationsOn ? "bell.badge" : "bell.slash"
            )
        }.onChange(of: settingViewModel.notificationsOn) { newValue in
            SoundManager.instance.playTab()
        }
    }
    
    private var soundEffectsToggle: some View {
        Toggle(isOn: settingViewModel.$soundOn) {
            labelWithIcon(
                text: "Sound effects",
                systemImage: settingViewModel.soundOn ? "speaker.wave.2" : "speaker.slash"
            )
        }.onChange(of: settingViewModel.soundOn) { newValue in
            SoundManager.instance.playTab()
        }
    }
    
    private var resetBtn: some View {
        Button {
            SoundManager.instance.playTab()
            settingViewModel.resetAllSettings()
        } label: {
            labelWithIcon(
                text: "Reset all settings",
                systemImage: "arrow.counterclockwise"
            )
        }
    }
    
    @ViewBuilder
    private func labelWithIcon(text: String, systemImage: String, iconPadding: Double = 8) -> some View {
        HStack {
            Image(systemName: systemImage)
                .padding(.horizontal, iconPadding)
                .foregroundColor(.theme.accent)
                .frame(minWidth: 40, alignment: .leading)
            Text(text)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
