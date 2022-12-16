//
//  AddAndRemoveSymbolFromListMenuContent.swift
//  Cryptify
//
//  Created by Jan Babák on 16.12.2022.
//

import SwiftUI
       
struct AddAndRemoveSymbolFromListMenuContent: View {
    @StateObject var marketsViewModel: MarketsViewModel
    var symbolId: String
    
    var body: some View {
        ForEach(marketsViewModel.listNames, id: \.self) { listName in
            if marketsViewModel.isSymbolInList(symbolId: symbolId, listName: listName) {
                Self.removeSymbolFromListButton(symbolId: symbolId, listName: listName, marketsViewModel: marketsViewModel)
            } else {
                Self.addSymbolToListButton(symbolId: symbolId, listName: listName, marketsViewModel: marketsViewModel)
            }
        }
    }
    
    @ViewBuilder
    static func removeSymbolFromListButton(symbolId: String, listName: String, marketsViewModel: MarketsViewModel) -> some View {
        if listName != SpecialMarketsList.all.rawValue {
            Button(role: .destructive) {
                marketsViewModel.removeSymbolFromList(symbolId: symbolId, listName: listName)
            } label: {
                Label("Remove from \(listName)", systemImage: "trash")
            }
        }
    }
    
    @ViewBuilder
    static func addSymbolToListButton(symbolId: String, listName: String, marketsViewModel: MarketsViewModel) -> some View {
        if listName != SpecialMarketsList.all.rawValue {
            Button {
                marketsViewModel.addSymbolToList(symbolId: symbolId, listName: listName)
            } label: {
                Label("Add to \(listName)", systemImage: listName == SpecialMarketsList.watchlist.rawValue ? "eye" : "plus")
            }
        }
    }
}

struct AddAndRemoveSymbolFromListMenuContent_Previews: PreviewProvider {
    static var previews: some View {
        AddAndRemoveSymbolFromListMenuContent(marketsViewModel: .init(), symbolId: "BTC_USDT")
    }
}
