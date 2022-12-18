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
            Text(LocalizedStringKey("trades"))
                .font(.title2)
                .fontWeight(.bold)

            if tickerViewModel.tradesState == .loading && tickerViewModel.trades.isEmpty {
                LoadingView()
            } else if tickerViewModel.tradesState == .error(), case let .error(message) = tickerViewModel.tradesState {
                ErrorView(
                    heading: "tradesNotAvailableError",
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
            gridHeaderItem(label: "price")
            gridHeaderItem(label: "sum")
            gridHeaderItem(label: "amount")
            
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
        Text(LocalizedStringKey(label))
            .foregroundColor(.theme.secondaryText)
            .fontWeight(.medium)
    }
}

struct TradesView_Previews: PreviewProvider {
    static var previews: some View {
        TradesView(tickerViewModel: .init(symbolId: "BTC_USDT"))
    }
}
