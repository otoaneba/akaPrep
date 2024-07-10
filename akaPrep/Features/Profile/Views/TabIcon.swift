//
//  TabIcon.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/7/24.
//

import SwiftUI


struct TabIcon: View {
    var icon: UIImage
    var size: CGSize = CGSize(width: 50, height: 50)

    // Based on https://stackoverflow.com/questions/58094384/swiftui-tabview-tabitem-with-custom-image-does-not-show
    var roundedIcon: UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        defer {
            // End context after returning to avoid memory leak
            UIGraphicsEndImageContext()
        }

        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height / 2
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
