//
//  DetailsView.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import SwiftUI

struct DetailsView: View {
    var ticker: Ticker
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), alignment: .leading),
                GridItem(.flexible(), alignment: .leading)
            ],
            spacing: 16
        ) {
            LabelPropertyView(label: "Low:", property: ticker.formattedLow)
            
            LabelPropertyView(label: "High:", property: ticker.formattedHigh)

            LabelPropertyView(label: "Open:", property: ticker.formattedOpen)
            
            LabelPropertyView(label: "Close:", property: ticker.formattedClose)
            
            LabelPropertyView(label: "Quantity:", property: ticker.formattedQuantity)
        
            LabelPropertyView(label: "TradeCount:", property: "\(ticker.tradeCount)")
        }
    }
}

struct LabelPropertyView: View {
    var label: String
    var property: String
    
    var body: some View {
        HStack() {
            Text(label)
                .foregroundColor(Color.theme.secondaryText)
                .font(.callout)
            
            Text(property)
                .fontWeight(.semibold)
                .font(.callout)
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(
            ticker: Ticker(
                symbol: "BTC_USDT",
                open: 1000.535904,
                close: 1003.543894,
                low: 1000.44554,
                high: 2000.5345,
                quantity: 8979,
                amount: 8479,
                tradeCount: 494,
                startTime: 7987897,
                closeTime: 8797989,
                displayName: "BTC/USDT",
                dailyChange: 1.03,
                ts: 3434
            )
        )
    }
}
