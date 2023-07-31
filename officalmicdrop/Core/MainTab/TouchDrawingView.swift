//
//  TouchDrawingView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 7/23/23.
//

import UIKit
import SwiftUI

struct TouchDrawingView: UIViewRepresentable {
    @Binding var squares: [Color]
    var selectedColor: Color
    @State private var path: [CGPoint] = []

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let gestureRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePanGesture(_:)))
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
            var parent: TouchDrawingView

            init(_ parent: TouchDrawingView) {
                self.parent = parent
            }

            @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
                let location = gestureRecognizer.location(in: gestureRecognizer.view)
                parent.path.append(location)

                for location in parent.path {
                    let x = Int(location.x) / 10
                    let y = Int(location.y) / 10
                    let index = y * 30 + x
                    if index >= 0 && index < parent.squares.count {
                        parent.squares[index] = parent.selectedColor
                    }
                }
            }
        }
    }
