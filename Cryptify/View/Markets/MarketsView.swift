//
//  MarketsView.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import SwiftUI

struct MarketsView: View {
    @StateObject var viewModel: MarketsViewModel = MarketsViewModel()
    
    var body: some View {
        Text("Marekts")
        ScrollView {
            if viewModel.sybols.isEmpty {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                ForEach(viewModel.sybols, id: \.symbol) { symbol in
                    Text(symbol.symbol)
                }
            }
        }
        .task {
            await viewModel.fetchSymbols()
        }
    }
}

struct MarketsView_Previews: PreviewProvider {
    static var previews: some View {
        MarketsView()
    }
}
