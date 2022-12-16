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
        .onAppear {
            print("appear")
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
    
    // MARK: - symbol list
    
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
                listSwitcher //set visible list
                
                Spacer()
                
                editListsMenu //create, delete, set default list
            }
            .padding(.bottom, 16)

            ListHeaderView(viewModel: viewModel) //sort headers
        }
        .listRowSeparator(.hidden)
        .padding(.bottom, -8)
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
        .swipeActions(edge: .leading, content: { //swipe from leading ege shortcut for adding symbol to watchlist, not available in Watchlist
            if viewModel.activeList != SpecialMarketsList.watchlist.rawValue {
                addSymbolToListButton(symbolId: symbol.symbol, listName: SpecialMarketsList.watchlist.rawValue)
                    .tint(.theme.accent)
            }
        })
        .swipeActions(edge: .trailing, content: { //swipe from trailing edge shortcut for removing symbol from active list, not available in All symbols
            if viewModel.activeList != SpecialMarketsList.all.rawValue {
                removeSymbolFromListButton(symbolId: symbol.symbol, listName: viewModel.activeList)
                    .tint(.theme.red)
            }
        })
        .contextMenu { //long press menu for adding symbol to lists and removing from lists
            listRowContextMenu(symbolId: symbol.symbol)
        }
    }
    
    // MARK: - inputs, menus
    
    //set visible list TODO: create menu and own lable, label is laggy
    private var listSwitcher: some View {
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
    
    //can add list, remove list, set list as default
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
        .alert("Create list", isPresented: $viewModel.createListAlertPresent) { //alert witch input field for entering list name
            TextField("Name", text: $viewModel.newListName)
            Button("Create") {
                viewModel.createList()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Create new list of symbols.")
        }
        .alert(
            isPresented: Binding(
                get: { viewModel.createListError != nil },
                set: {
                    if !$0 {
                        viewModel.createListError = nil
                    }
                }
            ),
            error: viewModel.createListError,
            actions: {}
        )
        .confirmationDialog( //delete list confirmation
            "Delete \(viewModel.activeList)?",
            isPresented: $viewModel.deleteListConfirmationDialogPresent,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive, action: viewModel.deleteActiveList)
        }
    }
    
    //content of long press menu on list row, menu for adding symbol into lists and removing symbol from lists
    private func listRowContextMenu(symbolId: String) -> some View {
        ForEach(viewModel.listNames, id: \.self) { listName in
            if viewModel.isSymbolInList(symbolId: symbolId, listName: listName) {
                removeSymbolFromListButton(symbolId: symbolId, listName: listName)
            } else {
                addSymbolToListButton(symbolId: symbolId, listName: listName)
            }
        }
    }
    
    // MARK: - buttons
    
    //button form creating list, opens alert, where is text field for list name
    private var createListButton: some View {
        Button {
            viewModel.createListAlertPresent = true
        } label: {
            Label("Create list", systemImage: "plus")
        }
    }
    
    //set list as default - default list = selected list when opening app
    @ViewBuilder
    private var setListAsDefaultButton: some View {
        // TODO: display only if active list != default list
        Button {
            viewModel.setActiveListAsDefault()
        } label: {
            Label("Set as default", systemImage: "pin")
        }
    }
    
    //delete list, All and Watchlist list can't be deleted
    @ViewBuilder
    private var deleteListButton: some View {
        if viewModel.activeList != SpecialMarketsList.all.rawValue && viewModel.activeList != SpecialMarketsList.watchlist.rawValue {
            Button(role: .destructive) {
                viewModel.deleteListConfirmationDialogPresent = true
            } label: {
                Label("Delete list", systemImage: "trash")
            }
        }
    }
    
    //button for removing symbol from list, symbol can't be removed from All list
    @ViewBuilder
    private func removeSymbolFromListButton(symbolId: String, listName: String) -> some View {
        if listName != SpecialMarketsList.all.rawValue {
            Button(role: .destructive) {
                viewModel.removeSymbolFromList(symbolId: symbolId, listName: listName)
            } label: {
                Label("Remove from \(listName)", systemImage: "trash")
            }
        }
    }
    
    //add symbol to list button
    @ViewBuilder
    private func addSymbolToListButton(symbolId: String, listName: String) -> some View {
        if listName != SpecialMarketsList.all.rawValue {
            Button {
                viewModel.addSymbolToList(symbolId: symbolId, listName: listName)
            } label: {
                Label("Add to \(listName)", systemImage: listName == SpecialMarketsList.watchlist.rawValue ? "eye" : "plus")
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
