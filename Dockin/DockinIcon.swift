//
//  DockinIcon.swift
//  Dockin
//
//  Created by Codex on 5/4/26.
//

import AppKit
import SwiftUI

struct DockinIcon: View {
    var size: CGFloat = 18
    var color: Color = Color(red: 0.11, green: 0.48, blue: 0.96)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .stroke(color, lineWidth: size * 0.1)

            RoundedRectangle(cornerRadius: size * 0.06, style: .continuous)
                .fill(color)
                .frame(width: size * 0.56, height: size * 0.12)
                .offset(y: size * 0.22)
        }
        .frame(width: size, height: size)
    }
}

extension DockinIcon {
    static func menuBarImage(size: CGFloat = 18) -> NSImage {
        let imageSize = NSSize(width: size, height: size)

        let image = NSImage(size: imageSize, flipped: false) { rect in
            let strokeColor = NSColor.black
            let strokeWidth = size * 0.1

            let outerRect = rect.insetBy(dx: strokeWidth * 0.7, dy: strokeWidth * 0.9)
            let outerPath = NSBezierPath(
                roundedRect: outerRect,
                xRadius: size * 0.22,
                yRadius: size * 0.22
            )
            outerPath.lineWidth = strokeWidth
            strokeColor.setStroke()
            outerPath.stroke()

            let barSize = CGSize(width: size * 0.56, height: size * 0.12)
            let barOrigin = CGPoint(
                x: rect.midX - (barSize.width / 2),
                y: rect.minY + size * 0.16
            )
            let barRect = CGRect(origin: barOrigin, size: barSize)
            let barPath = NSBezierPath(
                roundedRect: barRect,
                xRadius: size * 0.06,
                yRadius: size * 0.06
            )
            strokeColor.setFill()
            barPath.fill()

            return true
        }

        image.isTemplate = true
        return image
    }
}
