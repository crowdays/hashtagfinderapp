//
//  CustomTabBar.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 7/23/23.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var showMenu: Bool
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack {
            if !showMenu {
                HStack(spacing: 50) {
                    Button(action: {
                        selectedIndex = 0
                    }) {
                        Image(systemName: "house.fill")
                            .imageScale(.large)
                            .foregroundColor(Color(red: 1.00, green: 0.84, blue: 0.00))  // RGB for Gold
                            .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    }
                    Button(action: {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "circle.circle")
                            .imageScale(.large)
                            .foregroundColor(Color(red: 1.00, green: 0.84, blue: 0.00))  // RGB for Gold
                            .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    }
                    Button(action: {
                        selectedIndex = 1
                    }) {
                        Image(systemName: "number.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(Color(red: 1.00, green: 0.84, blue: 0.00))  // RGB for Gold
                            .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            VStack {
                Divider()
                Spacer()
            }
            .background(Color.white)
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(showMenu: .constant(false), selectedIndex: .constant(0))
    }
}

