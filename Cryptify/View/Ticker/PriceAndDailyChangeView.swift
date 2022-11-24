//
//  PriceAndDailyChangeView.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import SwiftUI

struct PriceAndDailyChangeView: View {
    var symbol: Symbol
    
    var body: some View {
        HStack {
            Text("Price:")
                .font(.title3)
                .foregroundColor(.theme.secondaryText)
            
            Text(symbol.formattedPrice)
                .font(.title3)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text("24h:")
                .font(.title3)
                .foregroundColor(.theme.secondaryText)
            
            Image(systemName: symbol.dailyChange < 0 ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
                .foregroundColor(symbol.dailyChange < 0 ? .theme.red : .theme.green)
            
            Text(symbol.formattedDailyChange)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(symbol.dailyChange < 0 ? .theme.red : .theme.green)
        }
    }
}

struct PriceAndDailyChangeView_Previews: PreviewProvider {
    static var previews: some View {
        PriceAndDailyChangeView(
            symbol: Symbol(
                symbol: "BTC_USDT",
                firstCurrency: "BTC",
                secondCurrency: "USDT",
                price: 14435,
                time: 34349832,
                dailyChange: 2.39,
                ts: 4385734
            )
        )
    }
}

