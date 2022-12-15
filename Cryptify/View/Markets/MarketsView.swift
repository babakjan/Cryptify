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
            
            HStack {
                listPicker
                
                Spacer()
                
                editListsMenu
            }
            .padding(.bottom, 16)

            ListHeaderView(viewModel: viewModel)
        }
        .listRowSeparator(.hidden)
        .padding(.bottom, -8)
    }
    
    private var listPicker: some View {
        Menu {
            ForEach(viewModel.listNames, id: \.self) { listName in
                Button(listName) {
                    viewModel.activeList = listName
                }
            }
        } label: {
            Text("\(viewModel.activeList) \(Image(systemName: "chevron.up.chevron.down"))")
                .foregroundColor(.theme.accent)
        }
        .frame(minWidth: 128 , alignment: .leading)
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
            if viewModel.activeList != "Watchlist" {
                addSymbolToListButton(symbolId: symbol.symbol, listName: "Watchlist")
                    .tint(.theme.accent)
            }
        })
        .swipeActions(edge: .trailing, content: {
            if viewModel.activeList != "All" {
                removeSymbolFromList(symbolId: symbol.symbol, listName: viewModel.activeList)
                    .tint(.theme.red)
            }
        })
        .contextMenu {
            listRowContextMenu(symbolId: symbol.symbol)
        }
    }
    
    private func listRowContextMenu(symbolId: String) -> some View {
        ForEach(viewModel.listNames, id: \.self) { listName in
            if viewModel.isSymbolInList(symbolId: symbolId, listName: listName) {
                removeSymbolFromList(symbolId: symbolId, listName: listName)
            } else {
                addSymbolToListButton(symbolId: symbolId, listName: listName)
            }
        }
    }
    
    private var editListsMenu: some View {
        Menu {
            createListButton
            
            setListAsDefaultButton
            
            deleteListButton
        } label: {
            Text("\(Image(systemName: "ellipsis"))")
                .foregroundColor(.theme.accent)
                .font(.title2)
                .frame(minWidth: 64, alignment: .trailing)
        }
        .alert("Create list", isPresented: $viewModel.createListAlertPresent) {
            TextField("Name", text: $viewModel.newListName)
            Button("Create") {
                viewModel.createList()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Create new list of symbols.")
        }
        .confirmationDialog("Delete \(viewModel.activeList)?", isPresented: $viewModel.deleteListConfirmationDialogPresent, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: viewModel.deleteActiveList)
        }
    }
    
    private var createListButton: some View {
        Button {
            viewModel.createListAlertPresent = true
        } label: {
            Label("Create list", systemImage: "plus")
        }
    }
    
    @ViewBuilder
    private var setListAsDefaultButton: some View {
        if viewModel.activeList != MarketsViewModel.defaultMarketList {
            Button {
                viewModel.setActiveListAsDefault()
            } label: {
                Label("Set as default", systemImage: "pin")
            }
        }
    }
    
    @ViewBuilder
    private var deleteListButton: some View {
        if viewModel.activeList != "All" && viewModel.activeList != "Watchlist" {
            Button(role: .destructive) {
                viewModel.deleteListConfirmationDialogPresent = true
            } label: {
                Label("Delete list", systemImage: "trash")
            }
        }
    }
    
    @ViewBuilder
    private func removeSymbolFromList(symbolId: String, listName: String) -> some View {
        if listName != "All" {
            Button(role: .destructive) {
                viewModel.removeSymbolFromList(symbolId: symbolId, listName: listName)
            } label: {
                Label("Remove from \(listName)", systemImage: "trash")
            }
        }
    }
    
    @ViewBuilder
    private func addSymbolToListButton(symbolId: String, listName: String) -> some View {
        if listName != "All" {
            Button {
                viewModel.addSymbolToList(symbolId: symbolId, listName: listName)
            } label: {
                Label("Add to \(listName)", systemImage: listName == "Watchlist" ? "eye" : "plus")
            }
        }
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
