//
//  ErrorView.swift
//  Cryptify
//
//  Created by Jan Babák on 12.12.2022.
//

import SwiftUI

struct ErrorView: View {
    var heading: LocalizedStringKey = "Something went wrong!" //for example error name
    var paragraph = "You may have lost your connection or the server is currently unavailable. Please try it later." //detailet error description, solution, ...
    var showTryAgainButton = false
    var tryAgainAction: () async -> Void = { } //for example reload, when showTryAgainButton is true
    var showImage = true //if true show image of disconnected server and client
    var imageWidth: CGFloat = 272
    
    var body: some View {
        VStack(alignment: .center) {
            if showImage {
                Image("error")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth)
                    .padding(.bottom, 24)
            }
            
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
            Image(systemName: "arrow.clockwise")
                .resizable()
                .scaledToFit()
                .frame(width: 28)
                .foregroundColor(.theme.accent)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(showTryAgainButton: true)
            .preferredColorScheme(.dark)
    }
}
