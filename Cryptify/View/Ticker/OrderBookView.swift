//
//  OrderBookView.swift
//  Cryptify
//
//  Created by Jan Babák on 06.12.2022.
//

import SwiftUI

struct OrderBookView: View {
    @StateObject var tickerViewModel: TickerViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("orderBook"))
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, -8)
            
            if tickerViewModel.orderBookState == .loading && tickerViewModel.orderBook == nil {
                LoadingView()
                    .padding(.top, 8)
            } else if tickerViewModel.orderBookState == .error(), case let .error(message) = tickerViewModel.orderBookState {
                error(message: message)
            } else if let orderBook = tickerViewModel.orderBook {
                grid(title: "bids", data: orderBook.bids, foregroundColor: .theme.green)

                grid(title: "asks", data: orderBook.asks, foregroundColor: .theme.red)
            }
        }
    }
    
    private func error(message: String) -> some View {
        ErrorView(
            heading: NSLocalizedString("orderBookNotAvailableError", comment: "Order book error heading."),
            paragraph: message,
            showTryAgainButton: true,
            tryAgainAction: tickerViewModel.fetchOrderBook,
            showImage: false
        )
        .padding(.top, 8)
    }
    
    @ViewBuilder
    private func grid(title: String, data: [PriceAmountPair], foregroundColor: Color = .theme.text) -> some View {
        let columns = [
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .trailing)
        ]
        
        Group {
            Text(LocalizedStringKey(title))
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom, -16)
            
            LazyVGrid(columns: columns, spacing: 8) {
                gridHeaderItem(label: "price")
                gridHeaderItem(label: "sum")
                gridHeaderItem(label: "amount")
                
                ForEach(data.indices, id: \.self) { index in
                    Text(Formatter.shared.formatToNumberOfdigits(of: data[index].price, maxNumberOfDigits: 6))
                    Text(Formatter.shared.formatToNumberOfdigits(of: data[index].price * data[index].amount, maxNumberOfDigits: 6))
                    Text("\(Formatter.shared.formatToNumberOfdigits(of: data[index].amount, maxNumberOfDigits: 6))")
                }
                .foregroundColor(foregroundColor)
            }
            .padding(.top, 0)
        }
        .padding(.top, 16)
    }
    
    private func gridHeaderItem(label: String) -> some View {
        Text(LocalizedStringKey(label))
            .foregroundColor(.theme.secondaryText)
            .fontWeight(.medium)
    }
}

struct OrderBookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookView(tickerViewModel: .init(symbolId: "BTC_USDT"))
    }
}
