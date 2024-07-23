//
//  MultiLineTitleView.swift
//  akaTask
//
//  Created by Naoto Abe on 7/23/24.
//

import SwiftUI

struct MultiLineTitleView: View {
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(nil)  // Allow multiline
        }
        .padding()
    }
}

#Preview {
    MultiLineTitleView(title: "Some Title asdfadsf asdf asdf asfdasdf ads fasdfasdf ")
}
