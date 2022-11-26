//
//  GridHeader.swift
//  Cryptify
//
//  Created by Jan Babák on 26.11.2022.
//

import SwiftUI

//header of the grid, contains sorting functionality
struct GridHeaderView: View {
    @StateObject var viewModel: MarketsViewModel
    
    var body: some View {
        Group {
            //pair
            HStack {
                Text("Pair")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortBy == .pairAscending || viewModel.sortBy == .pairDescendig ? 1 : 0)
                    .rotationEffect(Angle(degrees: viewModel.sortBy == .pairAscending ? 180 : 0))
            }
            .onTapGesture {
                withAnimation {
                    viewModel.sortBy = viewModel.sortBy == .pairAscending ? .pairDescendig : .pairAscending
                }
                viewModel.sortSymbols()
            }
            
            //price
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortBy == .priceAscending || viewModel.sortBy == .priceDescending ? 1 : 0)
                    .rotationEffect(Angle(degrees: viewModel.sortBy == .priceAscending ? 180 : 0))
            }
            .onTapGesture {
                withAnimation {
                    viewModel.sortBy = viewModel.sortBy == .priceAscending ? .priceDescending : .priceAscending
                }
                viewModel.sortSymbols()
            }
            
            //daily change
            HStack {
                Text("24h")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortBy == .dailyChangeAscenging || viewModel.sortBy == .dailyChangeDescending ? 1 : 0)
                    .rotationEffect(Angle(degrees: viewModel.sortBy == .dailyChangeAscenging ? 180 : 0))
            }
            .onTapGesture {
                withAnimation {
                    viewModel.sortBy = viewModel.sortBy == .dailyChangeAscenging ? .dailyChangeDescending : .dailyChangeAscenging
                }
                viewModel.sortSymbols()
            }
        }
        .fontWeight(.semibold)
    }
}

struct GridHeader_Previews: PreviewProvider {
    static var previews: some View {
        GridHeaderView(viewModel: .init())
    }
}
