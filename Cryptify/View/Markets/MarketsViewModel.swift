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
    
    init(symbols: [Symbol] = []) {
        self.symbols = symbols
    }
    
    @MainActor
    func fetchSymbols() async {
        symbols = await symbolApi.fetchAllSymbols().sorted(by: { $0.price > $1.price })
        lastUpdateDate = Date.now
    }
}
