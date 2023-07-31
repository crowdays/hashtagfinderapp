//
//  Textarea.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 5/29/23.
//

import SwiftUI

struct Textarea: View {
    @Binding var text: String
    let placeholder: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
        UITextView.appearance().backgroundColor = .clear
    }

    var body: some View {
        TextEditor(text: $text)
            .padding(4)
            .overlay(
                HStack {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(Color(.placeholderText))
                            .padding(.all, 8)
                        Spacer()
                    }
                }
            )
    }
}




