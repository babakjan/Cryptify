//
//  TodayHeadingView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

//display date of last update of markets data (symbols)
struct LastUpdateView: View {
    private let lastUpdateDate: Date?
    private let formatter: DateFormatter
    
    init(lastUpdateDate: Date?) {
        self.lastUpdateDate = lastUpdateDate
        formatter = DateFormatter()
        formatter.dateFormat = "MMMM d HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX") //translate from localized to english
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text("Last update: ")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.theme.secondaryText)
            
            if let date = lastUpdateDate {
                Text(formatter.string(from: date).capitalized)
                    .fontWeight(.semibold)
            } else {
                Text("-") //TODO get last updated date from disk?
            }
                
            Spacer()
        }
    }
}

struct TodayHeadingView_Previews: PreviewProvider {
    static var previews: some View {
        LastUpdateView(lastUpdateDate: Date.now)
    }
}
