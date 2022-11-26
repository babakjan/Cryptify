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
}
