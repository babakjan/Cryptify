//
//  MarketsViewModel.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import Foundation

final class MarketsViewModel: ObservableObject {
    @Published var symbols: [Symbol]
    @Published public var searchedText = ""
    @Published var lastUpdateDate: Date?
    @Published var sortBy: SortSymbolsBy = .priceDescending
    
    let symbolApi: SymbolAPI = .init()
    
    //search filter
    var searchResult: [Symbol] {
        if searchedText.isEmpty {
            return symbols
        }
        return symbols.filter { symbol in
            symbol.firstCurrency.lowercased().contains(searchedText.lowercased())
        }
    }
    
    init(symbols: [Symbol] = []) {
        self.symbols = symbols
    }
    
    @MainActor
    func fetchSymbols() async {
        symbols = await symbolApi.fetchAllSymbols().sorted(by: { $0.price > $1.price })
        lastUpdateDate = Date.now
    }
    
    func sortSymbols() {
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
    
    enum SortSymbolsBy {
        case priceAscending
        case priceDescending
        case pairAscending
        case pairDescendig
        case dailyChangeAscenging
        case dailyChangeDescending
        case none
    }
}
