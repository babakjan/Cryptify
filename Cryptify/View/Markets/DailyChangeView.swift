//
//  DailyChangeView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

//daily price change chip
struct DailyChangeView: View {
    let dailyChage: Double
    let dailyChangeFormatted: String
    let styles: Styles
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(dailyChage < 0 ? styles.colors["red"]! : styles.colors["green"]!)
            .frame(width: 72, height: 28)
            .overlay {
                Text(dailyChangeFormatted)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
    }
}

struct DailyChangeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyChangeView(
            dailyChage: 23.4,
            dailyChangeFormatted: "23.40%",
            styles: .init()
        )
    }
}
