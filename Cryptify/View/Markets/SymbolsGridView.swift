//
//  SymbolView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

struct SymbolsGridView: View {
    @StateObject var viewModel: MarketsViewModel
    @State private var searchedText = ""
    let styles: Styles = Styles()
    
    //search filter
    var searchResult: [Symbol] {
        if searchedText.isEmpty {
            return viewModel.symbols
        }
        return viewModel.symbols.filter { symbol in
            symbol.firstCurrency.lowercased().contains(searchedText.lowercased())
        }
    }
    
    var body: some View {
            if viewModel.symbols.isEmpty {
                SymbolsGridLoading()
            } else {
                let columns = [
                    GridItem(.flexible(), spacing: 0, alignment: .leading),
                    GridItem(.flexible(), spacing: 0, alignment: .leading),
                    GridItem(.flexible(), spacing: 0, alignment: .trailing)
                ]
                NavigationView {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            //header
                            Text("Pair").font(.headline).fontWeight(.semibold)
                            Text("Price").font(.headline).fontWeight(.semibold)
                            Text("24h change").font(.headline).fontWeight(.semibold)
                            
                            //body
                            ForEach(searchResult, id: \.symbol) { symbol in
                                PairView(symbol: symbol, styles: styles) //TODO where to instantiate styles???
                                
                                Text(symbol.formattedPrice)
                                
                                DailyChangeView(
                                    dailyChage: symbol.dailyChange,
                                    dailyChangeFormatted: symbol.formattedDailyChange,
                                    styles: styles
                                )
                                
                                RowSeparatorView(styles: styles)
                            }
                        }
                        .padding(.horizontal, 16)
                        .searchable(text: $searchedText)
                    }
                }
            }
    }
}

struct SymbolView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolsGridView(
            viewModel: MarketsViewModel(
                symbols: [
                    Symbol(
                        symbol: "BTC / USDT1",
                        firstCurrency: "BTC",
                        secondCurrency: "USDT",
                        price: 1344.90,
                        time: 5435234523,
                        dailyChange: 4.43,
                        ts: 485930458
                    ),
                    Symbol(
                        symbol: "BTC / USDT2",
                        firstCurrency: "BTC",
                        secondCurrency: "USDT",
                        price: 1344.9089009,
                        time: 5435234523,
                        dailyChange: -123.43,
                        ts: 485930458
                    ),
                    Symbol(
                        symbol: "BTC / USDT3",
                        firstCurrency: "BTC",
                        secondCurrency: "USDT",
                        price: 1344.90,
                        time: 5435234523,
                        dailyChange: -4.43,
                        ts: 485930458
                    ),
                    Symbol(
                        symbol: "BTC / USDT4",
                        firstCurrency: "BTC",
                        secondCurrency: "USDT",
                        price: 1344.90,
                        time: 5435234523,
                        dailyChange: 4.43,
                        ts: 485930458
                    ),
                    Symbol(
                        symbol: "BTC / USDT",
                        firstCurrency: "BTC",
                        secondCurrency: "USDT",
                        price: 1344.90,
                        time: 5435234523,
                        dailyChange: 4.43,
                        ts: 485930458
                    )
                ]
            )
        )
    }
}
