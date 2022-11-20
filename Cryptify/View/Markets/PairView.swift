//
//  PairView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

//first column in grid - eg. BTC / USDT
struct PairView: View {
    let symbol: Symbol
    let styles: Styles
    
    var body: some View {
        Text(symbol.firstCurrency)
            .font(.body)
            .fontWeight(.bold)
        +
        Text(" / \(symbol.secondCurrency)")
            .font(.body)
            .fontWeight(.light)
            .foregroundColor(styles.colors["black50"])
    }
}

struct PairView_Previews: PreviewProvider {
    static var previews: some View {
        PairView(
            symbol: Symbol(
                symbol: "BTC / USDT1",
                firstCurrency: "BTC",
                secondCurrency: "USDT",
                price: 1344.90,
                time: 5435234523,
                dailyChange: 4.43,
                ts: 485930458
            ),
            styles: .init()
        )
    }
}
