//
//  MarketsViewModel.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import Foundation
import SwiftUI

final class MarketsViewModel: ObservableObject {
    @Published private(set) var symbols: [Symbol]
    @Published private(set) var symbolsState = ResourceState.ok
    @Published private(set) var watchlistIds = Set<String>()
    @Published private(set) var lastUpdateDate: Date?
    @Published var activeList = ActiveList.all
    @Published var searchedText = ""
    @Published var sortBy: SortSymbolsBy = .priceDescending {
        didSet {
            sortSymbols()
        }
    }
    
    private let symbolApi: SymbolAPI = .init()
    
    //search filter
    var searchResult: [Symbol] {
        if searchedText.isEmpty {
            return activeList == ActiveList.watchlist ? watchlist : symbols
        }
        return (activeList == ActiveList.watchlist ? watchlist : symbols).filter { symbol in
            symbol.firstCurrency.lowercased().contains(searchedText.lowercased())
        }
    }
    
    //list of symbols in watchlist
    var watchlist: [Symbol] {
        return symbols.filter { symbol in
            watchlistIds.contains(symbol.symbol)
        }
    }
    
    init(symbols: [Symbol] = []) {
        self.symbols = symbols
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
        let index = symbols.firstIndex(where: { $0.symbol == symbolId })
        if let index {
            return index < symbols.count - 1 ? symbols[index + 1] : nil
        }
        return nil
    }
    
    func addSymbolToWatchlist(symbolId: String) {
        watchlistIds.insert(symbolId)
    }
    
    func removeSymbolFromWatchlist(symbolId: String) {
        watchlistIds.remove(symbolId)
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
