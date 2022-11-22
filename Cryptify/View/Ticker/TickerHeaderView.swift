//
//  TickerHeaderView.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import SwiftUI

struct TickerHeaderView: View {
    var onCloseIconClick: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            HeaderLogoView()
            
            Spacer()
            
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .onTapGesture {
                    onCloseIconClick()
                }
        }
    }
}

struct TickerHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TickerHeaderView(onCloseIconClick: { })
    }
}
