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
    
    var body: some View {
        Group {
            if viewModel.symbols.isEmpty {
                SymbolsGridLoading()
            } else {
                ScrollView {
                    LastUpdateView(lastUpdateDate: viewModel.lastUpdateDate)
                        .padding(.horizontal, 16)
                    
                    let columns = [
                        GridItem(.flexible(), spacing: 0, alignment: .leading),
                        GridItem(.flexible(), spacing: 0, alignment: .leading),
                        GridItem(.flexible(), spacing: 0, alignment: .trailing)
                    ]
                    LazyVGrid(columns: columns, spacing: 16) {
                        gridHeader
                        
                        gridBody()
                    }
                    .padding(.horizontal, 16)
                    .searchable(text: $searchedText)
                    .navigationDestination(for: Symbol.self) { symbol in
                        TickerDetailView(symbol: symbol.symbol, navigationPath: $navigationPath)
                    }
                }
            }
        }
        .navigationTitle("Markets")
        .toolbar {
            ToolbarItem(placement: .principal) {
                MarketsHeaderView()
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
    var gridHeader: some View {
        Text("Pair").font(.headline).fontWeight(.semibold)
        Text("Price").font(.headline).fontWeight(.semibold)
        Text("24h change").font(.headline).fontWeight(.semibold)
    }
    
    @ViewBuilder
    func gridBody() -> some View {
        ForEach(searchResult, id: \.symbol) { symbol in
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
    
    //filtered symbols after search
    var searchResult: [Symbol] {
        if searchedText.isEmpty {
            return viewModel.symbols
        }
        return viewModel.symbols.filter { symbol in
            symbol.firstCurrency.lowercased().contains(searchedText.lowercased())
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
