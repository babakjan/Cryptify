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
    
    var body: some View {
        Group {
            if viewModel.symbols.isEmpty {
                SymbolsGridLoading()
            } else {
                ScrollView {
                    LastUpdateView(lastUpdateDate: viewModel.lastUpdateDate)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)

                    symbolsGrid
                        .padding(.horizontal, 16)
                }
            }
        }
        .searchable(text: $viewModel.searchedText)
        .navigationTitle("Markets")
        .toolbar {
            ToolbarItem(placement: .principal) {
                ToolbarHeaderView(icon: "gearshape.2", iconIsNavigationLink: true) {
                    SettingsView(navigationPath: $navigationPath)
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
    
    @ViewBuilder
    var symbolsGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: 0, alignment: .leading),
            GridItem(.flexible(), spacing: 0, alignment: .leading),
            GridItem(.flexible(), spacing: 0, alignment: .trailing)
        ]
        LazyVGrid(columns: columns, spacing: 16) {
            GridHeaderView(viewModel: viewModel)
            
            gridBody()
        }
        .navigationDestination(for: Symbol.self) { symbol in
            TickerDetailView(symbol: symbol.symbol, navigationPath: $navigationPath)
        }
    }
    
    @ViewBuilder
    func gridBody() -> some View {
        ForEach(viewModel.searchResult, id: \.symbol) { symbol in
            gridRow(symbol: symbol)
                .onTapGesture {
                    navigationPath.append(symbol)
                }
        }
    }

    @ViewBuilder
    func gridRow(symbol: Symbol) -> some View {
        PairView(symbol: symbol)
        
        Text(symbol.formattedPrice)
        
        DailyChangeView(dailyChage: symbol.dailyChange, dailyChangeFormatted: symbol.formattedDailyChange)
        
        rowSeparator
    }

    
    //work around for creating grid row separator
    var rowSeparator: some View {
        ForEach(0..<3) { _ in //if adding new columns, don't forget to increment range
            Rectangle()
                .fill(Color.theme.lightGray)
                .frame(height: 1)
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
