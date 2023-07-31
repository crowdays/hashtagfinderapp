//
//  CustomInputView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/1/23.
//

import SwiftUI

struct CustomInputView: View {
    let imageName: String
    let placeholderText: String
    let isSecureField: Bool?
    @Binding var text: String
    
    init(imageName: String, placeholderText: String, text: Binding<String>, isSecureField: Bool? = false) {
        self.imageName = imageName
        self.placeholderText = placeholderText
        self._text = text
        self.isSecureField = isSecureField
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
                
                if isSecureField ?? false {
                    SecureField(placeholderText, text: $text)
                } else {
                    TextField(placeholderText, text: $text)
                }
            }
            Divider()
                .background(Color(.darkGray))
        }
    }
}

struct CustomInputView_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputView(imageName: "envelope",
                        placeholderText: "Email",
                        text: .constant(""))
    }
}
