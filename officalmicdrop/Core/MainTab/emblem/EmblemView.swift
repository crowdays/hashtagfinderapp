//
//  EmblemView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 7/23/23.
//

import SwiftUI

struct EmblemView: View {
    var squares: [Color]

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<squares.count, id: \.self) { index in
                Path { path in
                    let size = geometry.size.width / sqrt(CGFloat(squares.count))
                    let x = size * CGFloat(index % Int(sqrt(CGFloat(squares.count))))
                    let y = size * CGFloat(index / Int(sqrt(CGFloat(squares.count))))
                    path.addRect(CGRect(x: x, y: y, width: size, height: size))
                }
                .fill(squares[index])
            }
        }
        .frame(width: 30, height: 30)
    }
}
