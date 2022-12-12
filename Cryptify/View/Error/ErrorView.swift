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
    var showTryAgainButton = false
    var tryAgainButtonLabel = "Try again"
    var tryAgainAction: () async -> Void = { } //for example reload
    
    var body: some View {
        VStack(alignment: .center) {
            Image("error")
                .resizable()
                .scaledToFit()
                .frame(width: 272)
                .padding(.bottom, 24)
            
            Text(heading)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            Text(paragraph)
                .font(.subheadline)
                .foregroundColor(.theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)
            
            if showTryAgainButton {
                tryAgainButton
            }
        }
    }
    
    private var tryAgainButton: some View {
        Button {
            Task {
                await tryAgainAction()
            }
        } label: {
            HStack {
                Text(tryAgainButtonLabel)
                    .font(.title2)
                
                Image(systemName: "arrow.clockwise")
            }
            .foregroundColor(.white)
            .frame(width: 160)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(showTryAgainButton: true)
            .preferredColorScheme(.dark)
    }
}
