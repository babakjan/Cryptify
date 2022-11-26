//
//  RowSeparatorView.swift
//  Cryptify
//
//  Created by Jan Babák on 20.11.2022.
//

import SwiftUI

//row separators workaround
struct RowSeparatorView: View {

    var body: some View {
        ForEach(0..<3) { _ in //if adding new columns, don't forget to increment range
            Rectangle()
                .fill(Color.theme.lightGray)
                .frame(height: 1)
        }
    }
}

struct RowSeparatorView_Previews: PreviewProvider {
    static var previews: some View {
        RowSeparatorView()
    }
}
