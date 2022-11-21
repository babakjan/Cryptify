//
//  SymbolView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

struct MarketsView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject var viewModel: MarketsViewModel = MarketsViewModel()
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
        Group {
            if viewModel.symbols.isEmpty {
                SymbolsGridLoading()
            } else {
                ScrollView {
                    HStack {
                        TodayHeadingView(styles: styles)
                        Spacer()
                        ConnectionStatus(styles: styles)
                    }
                    .padding(.horizontal, 16)
                    .navigationTitle("Markets")
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            MarketsHeaderView()
                        }
                    }
                    
                    let columns = [
                        GridItem(.flexible(), spacing: 0, alignment: .leading),
                        GridItem(.flexible(), spacing: 0, alignment: .leading),
                        GridItem(.flexible(), spacing: 0, alignment: .trailing)
                    ]
                    LazyVGrid(columns: columns, spacing: 16) {
                        //header
                        Text("Pair").font(.headline).fontWeight(.semibold)
                        Text("Price").font(.headline).fontWeight(.semibold)
                        Text("24h change").font(.headline).fontWeight(.semibold)
                        
                        //body
                        ForEach(searchResult, id: \.symbol) { symbol in
                            PairView(symbol: symbol, styles: styles) //TODO where to instantiate styles???
                                .onTapGesture { //TODO how to create link, when row is clicked???
                                    navigationPath.append(symbol)
                                }
                            
                            Text(symbol.formattedPrice)
                                .onTapGesture {
                                    navigationPath.append(symbol)
                                }
                            
                            DailyChangeView(
                                dailyChage: symbol.dailyChange,
                                dailyChangeFormatted: symbol.formattedDailyChange,
                                styles: styles
                            )
                            .onTapGesture {
                                navigationPath.append(symbol)
                            }
                            
                            RowSeparatorView(styles: styles)
                        }
                    }
                    .padding(.horizontal, 16)
                    .searchable(text: $searchedText)
                    .navigationDestination(for: Symbol.self) { symbol in
                        TickerDetailView(symbol: symbol.symbol)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchSymbols()
        }
        .refreshable {
            await viewModel.fetchSymbols()
        }
    }
}

struct SymbolView_Previews: PreviewProvider {
    static var previews: some View {
        MarketsView(
            navigationPath: .constant(NavigationPath()),
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
