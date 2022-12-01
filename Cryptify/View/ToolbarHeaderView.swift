//
//  TickerHeaderView.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import SwiftUI

struct ToolbarHeaderView<Destination: View>: View {
    var icon: String //system name of icon and place it on the right side
    var iconAction: () -> Void //icon on tab gesture action
    var iconIsNavigationLink: Bool //if icon is navigation link
    var destination: Destination //if action is navigation link, this is destination for that link
    
    init(
        icon: String = "",
        iconAction: @escaping () -> Void = {},
        iconIsNavigationLink: Bool = false,
        destination: () -> Destination = { EmptyView() }
    ) {
        self.icon = icon
        self.iconAction = iconAction
        self.iconIsNavigationLink = iconIsNavigationLink
        self.destination = destination()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            HeaderLogoView()
            
            Spacer()
            
            if !icon.isEmpty {
                if iconIsNavigationLink {
                    NavigationLink(destination: destination) {
                        iconView
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        SoundManager.instance.playTab()
                    })
                } else {
                    iconView
                        .onTapGesture {
                            SoundManager.instance.playTab()
                            iconAction()
                        }
                }
            }
        }
    }
    
    var iconView: some View {
        Image(systemName: icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 24)
    }
}

struct TickerHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarHeaderView(iconAction: {}) {
            EmptyView()
        }
    }
}
