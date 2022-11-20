//
//  MarketsView.swift
//  Cryptify
//
//  Created by Jan Babák on 19.11.2022.
//

import SwiftUI

struct MarketsView: View {
    @StateObject var viewModel: MarketsViewModel = MarketsViewModel()
    
    let styles = Styles()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            //fixed header
            MarketsHeaderView()
            
            //scrollable rest of the view
            VStack(alignment: .leading) {
                Text("Markets")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal, 16)
                
                HStack {
                    TodayHeadingView(styles: styles)
                    
                    Spacer()
                    
                    ConnectionStatus(styles: styles)
                }
                .padding(.horizontal, 16)
                
                SymbolsGridView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchSymbols()
            }
            .refreshable {
                await viewModel.fetchSymbols()
            }
        }
    }
}

struct MarketsView_Previews: PreviewProvider {
    static var previews: some View {
        MarketsView()
    }
}
