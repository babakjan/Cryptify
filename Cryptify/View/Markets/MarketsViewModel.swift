//
//  MarketsViewModel.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import Foundation

final class MarketsViewModel: ObservableObject {
    @Published var sybols: [Symbol] = []
    let api: API<Symbol> = API<Symbol>()
    
    @MainActor
    func fetchSymbols() async {
        sybols = await api.fetchAll(url: "/price")
    }
}
