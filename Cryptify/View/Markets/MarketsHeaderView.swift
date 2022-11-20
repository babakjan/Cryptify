//
//  MarketsHeaderView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

struct MarketsHeaderView: View {
    var body: some View {
        HStack {
            HeaderLogoView()
            
            Spacer()
            
            Image(systemName: "gearshape.2") //TODO add navigation to settings
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
        }
        .padding(.horizontal, 16)    }
}

struct MarketsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MarketsHeaderView()
    }
}
