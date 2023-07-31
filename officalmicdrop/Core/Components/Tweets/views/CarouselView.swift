//
//  CarouselView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/16/23.
//

import SwiftUI
import Kingfisher



struct CarouselView: View {
    @State private var selectedIndex = 0
    var images: [KFImage] // Your array of KFImage objects

    var body: some View {
        VStack(alignment: .center) {
            TabView(selection: $selectedIndex) {
                ForEach(images.indices, id: \.self) { index in
                    images[index]
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10)) // Clip shape to round the corners
                                                .tag(index)
                        .tag(index)
                        .shadow(color: .gray, radius: 5, x: 0, y: 5)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 150) // Adjust height as per your need
            .offset(x: -30) // moves the photos 50 points to the left
            
            HStack(spacing: 3) {
                ForEach(images.indices, id: \.self) { index in
                    Circle()
                        .fill(selectedIndex == index ? Color.yellow : Color.black)
                        .frame(width: 10, height: 10)
                }
            }
            .offset(x: -32, y: 20) // moves the dots 20 points up
        }
    }
}



struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView(images: [KFImage(URL(string: "https://your-url.com/your-image.jpg")!)]) // replace with your actual URL
    }
}

