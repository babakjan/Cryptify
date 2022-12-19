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
                .padding(.bottom, -8)

            if tickerViewModel.tradesState == .loading && tickerViewModel.trades.isEmpty {
                LoadingView()
                    .padding(.top, 8)
            } else if tickerViewModel.tradesState == .error(), case let .error(messageLocalizedKey) = tickerViewModel.tradesState {
                error(messageLocalizedKey: messageLocalizedKey)
            } else {
                grid()
            }
        }
    }
    
    private func error(messageLocalizedKey: String) -> some View {
        ErrorView(
            headingLocalizedKey: "tradesNotAvailableError",
            paragraphLocalizedKey: messageLocalizedKey,
            showTryAgainButton: true, tryAgainAction: tickerViewModel.fetchTrades,
            showImage: false
        )
        .padding(.top, 8)
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
        .padding(.top, 8)
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
