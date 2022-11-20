//
//  RowSeparatorView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

//row separators workaround
struct RowSeparatorView: View {
    let styles: Styles
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ForEach(0..<3) { _ in //if adding new columns, don't forget to increment range
            Rectangle()
                .fill(colorScheme == .light ? styles.colors["black10"]! : styles.colors["black75"]!)
                .frame(height: 1)
        }
    }
}

struct RowSeparatorView_Previews: PreviewProvider {
    static var previews: some View {
        RowSeparatorView(styles: .init())
    }
}
