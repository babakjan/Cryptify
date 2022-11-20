//
//  TodayHeadingView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

struct TodayHeadingView: View {
    let styles: Styles
    let today = Date.now
    let formatter = DateFormatter()
    @Environment(\.colorScheme) var colorScheme
    
    init(styles: Styles) {
        self.styles = styles
        formatter.dateFormat = "MMMM d"
        formatter.locale = Locale(identifier: "en_US_POSIX") //translate from localized to english
    }
    
    var body: some View {
        Text(formatter.string(from: today).capitalized)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(colorScheme == .light ? styles.colors["black25"] : styles.colors["black50"])
    }
}

struct TodayHeadingView_Previews: PreviewProvider {
    static var previews: some View {
        TodayHeadingView(styles: .init())
    }
}
