//
//  ErrorView.swift
//  Cryptify
//
//  Created by Jan Babák on 12.12.2022.
//

import SwiftUI

struct ErrorView: View {
    var heading = "Something went wrong!"
    var paragraph = "You may have lost your connection or the server is currently unavailable. Please try it later."
    
    var body: some View {
        VStack(alignment: .center) {
            Image("error")
                .resizable()
                .scaledToFit()
                .frame(width: 280)
                .padding(.bottom, 24)
            
            Text(heading)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            Text(paragraph)
                .font(.subheadline)
                .foregroundColor(.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
            .preferredColorScheme(.dark)
    }
}
