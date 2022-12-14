//
//  SymbolView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

struct MarketsView: View {
    @Binding var navigationPath: [Symbol]
    @StateObject var viewModel = MarketsViewModel()
    
    var body: some View {
        Group {
            if viewModel.symbolsState == ResourceState.loading {
                LoadingView()
                    .padding(.top, 128)
            } else if viewModel.symbolsState == ResourceState.error(), case let .error(message) = viewModel.symbolsState {
                error(message: message)
            } else {
                symbolList
            }
        }
        .searchable(text: $viewModel.searchedText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle("Markets")
        .toolbar {
            ToolbarItem(placement: .principal) {
                ToolbarHeaderView(icon: "gearshape.2", iconIsNavigationLink: true) {
                    SettingsView()
                }
            }
        }
        .task {
            await viewModel.fetchSymbols()
        }
        .refreshable {
            Task { //without this, task is cancelled due to ui rebuild, is there a better way?
                await viewModel.fetchSymbols()
            }
        }
    }
    
    private func error(message: String) -> some View {
        ErrorView(
            paragraph: message,
            showTryAgainButton: true,
            tryAgainAction: viewModel.fetchSymbols
        )
            .padding(.top, 64)
            .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var symbolList: some View {
        List {
            symbolListHeader
            
            symbolListBody
        }
        .listStyle(.plain)
        .navigationDestination(for: Symbol.self) { symbol in
            TickerDetailView(
                symbol: symbol.symbol,
                navigationPath: $navigationPath,
                marketsViewModel: viewModel
            )
        }
    }
    
    private var symbolListHeader: some View {
        VStack(alignment: .leading) {
            LastUpdateView(lastUpdateDate: viewModel.lastUpdateDate)
                .padding(.bottom, 16)
            
            listPicker
                .padding(.bottom, 16)

            ListHeaderView(viewModel: viewModel)
        }
        .listRowSeparator(.hidden)
        .padding(.bottom, -8)
    }
    
    private var listPicker: some View {
        Picker("List", selection: $viewModel.activeList) {
            ForEach(MarketsViewModel.ActiveList.allCases) { list in
                Text(list.rawValue)
                    .tag(list)
            }
        }
        .foregroundColor(.theme.accent)
    }
    
    @ViewBuilder
    private var symbolListBody: some View {
        ForEach(viewModel.searchResult, id: \.symbol) { symbol in
            //workaround in order to get rid of the arrow in the list row containing navigation link
            ZStack {
                NavigationLink (value: symbol) {
                    EmptyView()
                }
                .opacity(0)
    
                listRow(symbol: symbol)
            }
        }
    }

    @ViewBuilder
    private func listRow(symbol: Symbol) -> some View {
        HStack {
            PairView(symbol: symbol)
                .frame(minWidth: 148, alignment: .leading)
            
            Text(symbol.formattedPrice)
            
            Spacer()
            
            DailyChangeView(dailyChage: symbol.dailyChange, dailyChangeFormatted: symbol.formattedDailyChange)
        }
        .padding(.vertical, 6)
        .swipeActions(edge: .leading, content: {
            if viewModel.activeList == MarketsViewModel.ActiveList.all {
                Button {
                    viewModel.addSymbolToWatchlist(symbolId: symbol.symbol)
                } label: {
                    Label("Watched", systemImage: "eye")
                }
                .tint(.theme.accent)
            }
        })
        .swipeActions(edge: .trailing, content: {
            if viewModel.activeList == MarketsViewModel.ActiveList.watchlist {
                Button {
                    viewModel.removeSymbolFromWatchlist(symbolId: symbol.symbol)
                } label: {
                    Label("Remove from watchlist", systemImage: "trash")
                }
                .tint(.theme.red)
            }
        })
    }
}

struct SymbolView_Previews: PreviewProvider {
    static var previews: some View {
        MarketsView(
            navigationPath: .constant([]),
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
