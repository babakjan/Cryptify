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
                RemoveSymbolFromListButton(
                    symbolId: symbolId,
                    listName: listName,
                    marketsViewModel: marketsViewModel
                )
            } else {
               AddSymbolToListButton(
                symbolId: symbolId,
                listName: listName,
                marketsViewModel: marketsViewModel
               )
            }
        }
    }
}

struct RemoveSymbolFromListButton: View {
    var symbolId: String
    var listName: String
    
    @StateObject var marketsViewModel: MarketsViewModel
    
    var body: some View {
        if listName != SpecialMarketsList.all.rawValue {
            Button(role: .destructive) {
                marketsViewModel.removeSymbolFromList(symbolId: symbolId, listName: listName)
            } label: {
                HStack {
                    Text(LocalizedStringKey("removeFrom ")) + Text(LocalizedStringKey(listName))
                    Image(systemName: "trash")
                }
            }
        }
    }
}

struct AddSymbolToListButton: View {
    var symbolId: String
    var listName: String
    
    @StateObject var marketsViewModel: MarketsViewModel
    
    var body: some View {
        if listName != SpecialMarketsList.all.rawValue {
            Button {
                marketsViewModel.addSymbolToList(symbolId: symbolId, listName: listName)
            } label: {
                HStack {
                    Text(LocalizedStringKey("addTo ")) + Text(LocalizedStringKey(listName))
                    Image(systemName: listName == SpecialMarketsList.watchlist.rawValue ? "eye" : "plus")
                }
            }
        }
    }
}

struct AddAndRemoveSymbolFromListMenuContent_Previews: PreviewProvider {
    static var previews: some View {
        AddAndRemoveSymbolFromListMenuContent(marketsViewModel: .init(), symbolId: "BTC_USDT")
    }
}
