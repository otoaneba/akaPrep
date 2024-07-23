//
//  SpinnerViewRepresentable.swift
//  akaTask
//
//  Created by Naoto Abe on 7/23/24.
//

import SwiftUI
import UIKit

struct SpinnerViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> SpinnerView {
        return SpinnerView()
    }

    func updateUIView(_ uiView: SpinnerView, context: Context) {
        // Update the view if needed
    }
}
