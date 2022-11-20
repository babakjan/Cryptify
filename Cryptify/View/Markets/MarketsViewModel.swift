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
    
    let api: API<Symbol> = API<Symbol>()
    
    init(symbols: [Symbol] = []) {
        self.symbols = symbols
    }
    
    @MainActor
    func fetchSymbols() async {
        symbols = await api.fetchAll(url: "/price")
    }
}
