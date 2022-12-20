//
//  GridHeader.swift
//  Cryptify
//
//  Created by Jan Babák on 26.11.2022.
//

import SwiftUI

//header of the grid, contains sorting functionality
struct ListHeaderView: View {
    @StateObject var viewModel: MarketsViewModel
    
    var body: some View {
        HStack {
            pair
            
            Spacer()
            
            price
            
            dailyChange
        }
        .fontWeight(.semibold)
    }
    
    private var pair: some View {
        HStack {
            Text(LocalizedStringKey("pair"))
            Image(systemName: "chevron.down")
                .opacity(viewModel.sortBy == .pairAscending || viewModel.sortBy == .pairDescendig ? 1 : 0)
                .rotationEffect(Angle(degrees: viewModel.sortBy == .pairAscending ? 180 : 0))
        }
        .frame(maxWidth: viewModel.pairColumnWidth, alignment: .leading)
        .onTapGesture {
            SoundManager.shared.playTab()
            withAnimation {
                viewModel.sortBy = viewModel.sortBy == .pairAscending ? .pairDescendig : .pairAscending
            }
        }
    }
    
    private var price: some View {
        HStack {
            Text(LocalizedStringKey("price"))
            Image(systemName: "chevron.down")
                .opacity(viewModel.sortBy == .priceAscending || viewModel.sortBy == .priceDescending ? 1 : 0)
                .rotationEffect(Angle(degrees: viewModel.sortBy == .priceAscending ? 180 : 0))
        }
        .frame(width: 96, alignment: .leading)
        .onTapGesture {
            SoundManager.shared.playTab()
            withAnimation {
                viewModel.sortBy = viewModel.sortBy == .priceAscending ? .priceDescending : .priceAscending
            }
        }
    }
    
    private var dailyChange: some View {
        HStack {
            Text(LocalizedStringKey("24h"))
            Image(systemName: "chevron.down")
                .opacity(viewModel.sortBy == .dailyChangeAscenging || viewModel.sortBy == .dailyChangeDescending ? 1 : 0)
                .rotationEffect(Angle(degrees: viewModel.sortBy == .dailyChangeAscenging ? 180 : 0))
        }
        .frame(width: 76, alignment: .trailing)
        .onTapGesture {
            SoundManager.shared.playTab()
            withAnimation {
                viewModel.sortBy = viewModel.sortBy == .dailyChangeAscenging ? .dailyChangeDescending : .dailyChangeAscenging
            }
        }
    }
}

struct GridHeader_Previews: PreviewProvider {
    static var previews: some View {
        ListHeaderView(viewModel: .init())
    }
}
