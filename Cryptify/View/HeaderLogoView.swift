//
//  HeaderLogoView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

//header logo
struct HeaderLogoView: View {
    let styles: Styles = Styles()
    
    var body: some View {
        Text("_cryptify")
            .foregroundColor(styles.colors["primary"])
            .font(.custom("Menlo",fixedSize: 24)) //TODO change font
            .fontWeight(.bold)
            .padding(.bottom, 16)
    }
}

struct HeaderLogoView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderLogoView()
    }
}
