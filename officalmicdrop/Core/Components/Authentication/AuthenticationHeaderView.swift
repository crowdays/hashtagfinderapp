//
//  AuthenticationHeaderView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/3/23.
//

import SwiftUI

struct AuthenticationHeaderView: View {
    let title1: String
    let title2: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack { Spacer() }
            
            Text(title1)
                .font(.largeTitle)
                .fontWeight(.semibold)
                
            Text(title2)
                .font(.largeTitle)
                .fontWeight(.semibold)
                
                
            
        }
        .frame(height: 240)
        .padding(.leading)
        .background(Color(red: 1.00, green: 0.84, blue: 0.00))
        .foregroundColor(.white)
        .clipShape(RoundedShape(corners: (.bottomLeft)))
        .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y: 0 )
    }
}

struct AuthenticationHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationHeaderView(title1: "hello", title2: "welcome back")
    }
}
