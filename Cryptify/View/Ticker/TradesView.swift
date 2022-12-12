//
//  TradesView.swift
//  Cryptify
//
//  Created by Jan Babák on 10.12.2022.
//

import SwiftUI

struct TradesView: View {
    @StateObject var tickerViewModel: TickerViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Trades")
                .font(.title2)
                .fontWeight(.bold)

            if tickerViewModel.tradesState == .loading && tickerViewModel.trades.isEmpty {
                LoadingView()
            } else if tickerViewModel.tradesState == .error(), case let .error(message) = tickerViewModel.tradesState {
                ErrorView(
                    heading: "Trades are not available!",
                    paragraph: message,
                    showTryAgainButton: true, tryAgainAction: tickerViewModel.fetchTrades,
                    showImage: false
                )
            } else {
                grid()
            }
        }
    }
    
    @ViewBuilder
    private func grid() -> some View {
        let columns = [
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .trailing)
        ]
        
        LazyVGrid(columns: columns, spacing: 8) {
            gridHeaderItem(label: "Price")
            gridHeaderItem(label: "Sum")
            gridHeaderItem(label: "Amount")
            
            ForEach(tickerViewModel.trades) { trade in
                Group {
                    Text(Formatter.shared.formatToNumberOfdigits(of: trade.price * trade.amount))
                    Text(Formatter.shared.formatToNumberOfdigits(of: trade.amount * trade.price))
                    Text(Formatter.shared.formatToNumberOfdigits(of: trade.amount))
                }.foregroundColor(trade.color)
            }
        }
    }
    
    private func gridHeaderItem(label: String) -> some View {
        Text(label)
            .foregroundColor(.theme.secondaryText)
            .fontWeight(.medium)
    }
}

struct TradesView_Previews: PreviewProvider {
    static var previews: some View {
        TradesView(tickerViewModel: .init(symbolId: "BTC_USDT"))
    }
}
