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
        ZStack {
            if viewModel.symbolsState == ResourceState.error(), case let .error(message) = viewModel.symbolsState {
                error(message: message)
            }
            
            symbolList
                .opacity(viewModel.symbolsState == .ok ? 1 : 0)
            
            if viewModel.symbolsState == ResourceState.loading {
                LoadingView()
            }
            
        }
        .searchable(text: $viewModel.searchedText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle(LocalizedStringKey("markets"))
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
            await viewModel.fetchSymbols()
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
            
            HStack {
                listSwitcher //set visible list
                
                Spacer()
                
                editListsMenu //create, delete, set default list
            }

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
                .opacity(0.1)
    
                listRow(symbol: symbol)
            }
        }
        .onPreferenceChange(PairColumnWidthPreferenceKey.self) { width in
            viewModel.pairColumnWidth = width
        }
    }

    @ViewBuilder
    private func listRow(symbol: Symbol) -> some View {
        HStack {
            PairView(symbol: symbol, viewModel: viewModel)
                .frame(idealWidth: viewModel.pairColumnWidth, maxWidth: .infinity, alignment: .leading)
                .overlay {
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: PairColumnWidthPreferenceKey.self,
                            value: proxy.size.width
                        )
                    }
                }
            Spacer()
            
            Text(symbol.formattedPrice)
                .frame(width: 96, alignment: .leading)
            
            DailyChangeView(dailyChage: symbol.dailyChange, dailyChangeFormatted: symbol.formattedDailyChange)
        }
        .padding(.vertical, 6)
        .swipeActions(edge: .leading, content: { //swipe from leading ege shortcut for adding symbol to watchlist, not available in Watchlist
            if viewModel.activeList != SpecialMarketsList.watchlist.rawValue {
                AddSymbolToListButton(
                    symbolId: symbol.symbol,
                    listName: SpecialMarketsList.watchlist.rawValue,
                    swipeSound: true,
                    marketsViewModel: viewModel
                )
                    .tint(.theme.accent)
            }
        })
        .swipeActions(edge: .trailing, content: { //swipe from trailing edge shortcut for removing symbol from active list, not available in All symbols
            if viewModel.activeList != SpecialMarketsList.all.rawValue {
                RemoveSymbolFromListButton(
                    symbolId: symbol.symbol,
                    listName: viewModel.activeList,
                    swipeSound: true,
                    marketsViewModel: viewModel
                )
                    .tint(.theme.red)
            }
        })
        .contextMenu { //long press menu for adding symbol to lists and removing from lists
            AddAndRemoveSymbolFromListMenuContent(marketsViewModel: viewModel, symbolId: symbol.symbol)
        }
    }
    
    // MARK: - inputs, menus
    
    //set visible list
    private var listSwitcher: some View {
        Picker("List", selection: $viewModel.activeList) {
            ForEach(viewModel.listNames, id: \.self) { listName in
                Text(LocalizedStringKey(listName))
            }
        }
        .foregroundColor(.theme.accent)
        .labelsHidden()
        .padding(.leading, -11)
        .pickerStyle(.menu)
        .onChange(of: viewModel.activeList) { newValue in
            SoundManager.shared.playTab()
        }
        .onTapGesture {
            SoundManager.shared.playTab()
        }
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
                .frame(width: 64, height: 24, alignment: .trailing)
        }
        .onTapGesture {
            SoundManager.shared.playTab()
        }
        .alert(LocalizedStringKey("createList"), isPresented: $viewModel.createListAlertPresent) { //alert witch input field for entering list name
            TextField(LocalizedStringKey("name"), text: $viewModel.newListName)
            Button(LocalizedStringKey("create")) {
                SoundManager.shared.playTab()
                viewModel.createList()
            }
            Button(LocalizedStringKey("cancel"), role: .cancel) {
                SoundManager.shared.playTab()
            }
        } message: {
            Text(LocalizedStringKey("createListSubtitle"))
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
            LocalizedStringKey("delete \(viewModel.activeList)?"),
            isPresented: $viewModel.deleteListConfirmationDialogPresent,
            titleVisibility: .visible
        ) {
            Button(LocalizedStringKey("delete"), role: .destructive, action: viewModel.deleteActiveList)
        }
    }
    
    // MARK: - buttons
    
    //button form creating list, opens alert, where is text field for list name
    private var createListButton: some View {
        Button {
            SoundManager.shared.playTab()
            viewModel.createListAlertPresent = true
        } label: {
            Label(LocalizedStringKey("createList"), systemImage: "plus")
        }
    }
    
    //set list as default - default list = selected list when opening app
    @ViewBuilder
    private var setListAsDefaultButton: some View {
        if viewModel.activeList != MarketsViewModel.defaultMarketList {
            Button {
                SoundManager.shared.playTab()
                viewModel.setActiveListAsDefault()
            } label: {
                Label(LocalizedStringKey("setAsDefault"), systemImage: "pin")
            }
        }
    }
    
    //delete list, All and Watchlist list can't be deleted
    @ViewBuilder
    private var deleteListButton: some View {
        if viewModel.activeList != SpecialMarketsList.all.rawValue && viewModel.activeList != SpecialMarketsList.watchlist.rawValue {
            Button(role: .destructive) {
                SoundManager.shared.playTab()
                viewModel.deleteListConfirmationDialogPresent = true
            } label: {
                Label(LocalizedStringKey("deleteList"), systemImage: "trash")
            }
        }
    }
}

struct PairColumnWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0 //default width
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
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
