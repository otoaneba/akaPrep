//
//  TabIcon.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/7/24.
//

import SwiftUI


struct TabIcon: View {
    var icon: UIImage
    var size: CGSize = CGSize(width: 27, height: 27)

    // Based on https://stackoverflow.com/questions/58094384/swiftui-tabview-tabitem-with-custom-image-does-not-show
    var roundedIcon: UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        defer {
            // End context after returning to avoid memory leak
            UIGraphicsEndImageContext()
        }

        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
            ).addClip()
        icon.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    var body: some View {
        Image(uiImage: roundedIcon.withRenderingMode(.alwaysOriginal))
            .resizable()
            .frame(width: size.width, height: size.height)
    }
}
