//
//  TodayHeadingView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

struct TodayHeadingView: View {
    let today: Date
    let formatter: DateFormatter
    
    init() {
        today = Date.now
        formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        formatter.locale = Locale(identifier: "en_US_POSIX") //translate from localized to english
    }
    
    var body: some View {
        Text(formatter.string(from: today).capitalized)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.theme.secondaryText)
    }
}

struct TodayHeadingView_Previews: PreviewProvider {
    static var previews: some View {
        TodayHeadingView()
    }
}
