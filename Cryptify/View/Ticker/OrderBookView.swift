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
            Text("Order Book")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 16)
            
            if let orderBook = tickerViewModel.orderBook {
                grid(title: "Bids", data: orderBook.bids, foregroundColor: .theme.green)
                    .padding(.bottom, 16)
                
                grid(title: "Asks", data: orderBook.asks, foregroundColor: .theme.red)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
    
    @ViewBuilder
    private func grid(title: String, data: [PriceAmountPair], foregroundColor: Color = .theme.text) -> some View {
        let columns = [
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .trailing)
        ]
        
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
        
        LazyVGrid(columns: columns, spacing: 8) {
            Text("Price")
                .foregroundColor(.theme.secondaryText)
                .fontWeight(.medium)
            
            Text("Sum")
                .foregroundColor(.theme.secondaryText)
                .fontWeight(.medium)
            
            Text("Amount")
                .foregroundColor(.theme.secondaryText)
                .fontWeight(.medium)
            
            ForEach(data.indices, id: \.self) { index in
                Text(formattPrice(of: data[index].price, maxNumberOfDigits: 8))
                Text(formattPrice(of: data[index].price * data[index].amount, maxNumberOfDigits: 8))
                Text("\(data[index].amount)")
            }
            .foregroundColor(foregroundColor)
        }
    }
}

struct OrderBookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookView(tickerViewModel: .init(symbolId: "BTC_USDT"))
    }
}
