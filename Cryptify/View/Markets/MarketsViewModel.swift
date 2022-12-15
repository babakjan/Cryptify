//
//  MarketsViewModel.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import Foundation
import SwiftUI

final class MarketsViewModel: ObservableObject {
    @AppStorage("defaultMarketsList") static var defaultMarketList = "All"
    @Published private(set) var symbols: [Symbol]
    @Published private(set) var symbolsState = ResourceState.ok
    @Published private(set) var watchlistIds = Set<String>()
    @Published private(set) var lastUpdateDate: Date?
    @Published var marketLists: [String: Set<String>] //id is list name, value is list of symbol ids
    @Published var activeList = MarketsViewModel.defaultMarketList
    @Published var newListName = ""
    @Published var createListAlertPresent = false
    @Published var deleteListConfirmationDialogPresent = false
    @Published var searchedText = ""
    @Published var sortBy: SortSymbolsBy = .priceDescending {
        didSet {
            sortSymbols()
        }
    }
    private static let marketListsUserDefaultsKey = "marketLists"
    
    private let symbolApi: SymbolAPI = .init()
    
    //search filter
    var searchResult: [Symbol] {
        if searchedText.isEmpty {
            return symbolsInActiveList
        }
        return symbolsInActiveList.filter { symbol in
            symbol.firstCurrency.lowercased().contains(searchedText.lowercased())
        }
    }
    
    //list of symbols in watchlist
    var symbolsInActiveList: [Symbol] {
        if activeList == "All" {
            return symbols
        }
        return symbols.filter { symbol in
            (marketLists[activeList] ?? []).contains(symbol.symbol)
        }
    }
    
    var listNames: [String] {
        ["All"] + marketLists.keys.sorted(by: >)
    }
    
    init(symbols: [Symbol] = []) {
        self.symbols = symbols
        self.marketLists = ["Watchlist": []]
        
        loadMarketListsFromUserDefauls()
    }
    
    @MainActor
    func fetchSymbols() async {
        symbolsState = .loading
        
        do {
            symbols = try await symbolApi.fetchAllSymbols().sorted(by: { $0.price > $1.price })
        } catch {
            symbolsState = .error(message: error.localizedDescription)
            print("[ERROR] fetch symbols market view model")
            return
        }
        
        symbolsState = .ok
        lastUpdateDate = Date.now
    }
    
    func sortSymbols() {
        withAnimation(.none) {
            switch sortBy {
            case .pairAscending: self.symbols.sort(by: { $0.symbol < $1.symbol })
            case .pairDescendig: self.symbols.sort(by: { $0.symbol > $1.symbol })
            case .priceAscending: self.symbols.sort(by: { $0.price < $1.price })
            case .priceDescending: self.symbols.sort(by: { $0.price > $1.price })
            case .dailyChangeAscenging: self.symbols.sort(by: { $0.dailyChange < $1.dailyChange })
            case .dailyChangeDescending: self.symbols.sort(by: { $0.dailyChange > $1.dailyChange })
            default: return
            }
        }
    }
    
    //used for listing through symbols, when user is in ticker view and swipe for next symbol
    func getNextSymbol(symbolId: String) -> Symbol? {
        let index = searchResult.firstIndex(where: { $0.symbol == symbolId })
        if let index {
            return index < searchResult.count - 1 ? searchResult[index + 1] : nil
        }
        return nil
    }
    
    func addSymbolToWatchlist(symbolId: String) {
        marketLists["Watchlist"]?.insert(symbolId)
    }

    func removeSymbolFromWatchlist(symbolId: String) {
        marketLists["Watchlist"]?.remove(symbolId)
    }
    
    func addSymbolToList(symbolId: String, listName: String) {
        guard marketLists.keys.contains(listName) else {
            print("[LIST_NOT_EXISTS_ERROR]", listName)
            return
        }
        
        marketLists[listName]!.insert(symbolId)
        saveMarketListsToUserDefaults()
    }
    
    func removeSymbolFromList(symbolId: String, listName: String) {
        guard marketLists.keys.contains(listName) else {
            print("[LIST_NOT_EXISTS_ERROR]", listName)
            return
        }
        
        marketLists[listName]!.remove(symbolId)
        saveMarketListsToUserDefaults()
    }
    
    func createList() {
        if newListName.isEmpty {
            print("list is empty") // TODO: display error
            return
        }
        if marketLists.keys.contains(newListName) {
            print("list exists") // TODO: display error
            return
        }
        marketLists[newListName] = Set<String>()
        newListName = ""
    }
    
    func setActiveListAsDefault() {
        Self.defaultMarketList = activeList
    }
    
    func deleteActiveList() {
        let listToDelete = activeList
        activeList = "All"
        marketLists.removeValue(forKey: listToDelete)
    }
    
    func isSymbolInList(symbolId: String, listName: String) -> Bool {
        guard marketLists.keys.contains(listName) else {
            return false
        }
        return marketLists[listName]!.contains(symbolId)
    }
    
    private func saveMarketListsToUserDefaults() {
        let data = try? JSONEncoder().encode(marketLists)
        UserDefaults.standard.set(data, forKey: Self.marketListsUserDefaultsKey)
    }

    private func loadMarketListsFromUserDefauls() {
        guard let data = UserDefaults.standard.data(forKey: Self.marketListsUserDefaultsKey) else {
            marketLists =  ["Watchlist": Set<String>()]
            return
        }

        do {
            let decodedData = try JSONDecoder().decode([String : Set<String>].self, from: data)
            marketLists = decodedData
            return
        } catch {
            print("[DECODING_MARKET_LISTS_ERROR]", error.localizedDescription)
            marketLists =  ["Watchlist": Set<String>()]
        }
    }
    
    enum SortSymbolsBy {
        case priceAscending
        case priceDescending
        case pairAscending
        case pairDescendig
        case dailyChangeAscenging
        case dailyChangeDescending
        case none
    }
    
    enum ActiveList: String, CaseIterable, Identifiable {
        case all = "All"
        case watchlist = "Watchlist"
        
        var id: String {
            self.rawValue
        }
    }
}
