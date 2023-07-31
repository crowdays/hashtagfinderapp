//
//  EmblemCreationView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 7/23/23.
//

import SwiftUI



struct EmblemCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var emblems: [Emblem]
    @State private var selectedColor: Color = .black
    @State private var squares: [Color]
    var emblemIndex: Int?
    let name: String
    @State private var bio: String = ""

    init(emblems: Binding<[Emblem]>, emblem: Emblem? = nil, name: String = "") {
        _emblems = emblems
        self.name = name
        if let emblem = emblem {
            _squares = State(initialValue: emblem.squares.map { Color($0) })
            emblemIndex = emblems.wrappedValue.firstIndex(where: { $0.id == emblem.id })
        } else {
            _squares = State(initialValue: Array(repeating: .white, count: 15*15))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .stroke(Color.black, lineWidth: 10)
                        .frame(width: 160, height: 160)
                    
                    GeometryReader { geometry in
                        ForEach(0..<squares.count, id: \.self) { index in
                            Path { path in
                                let size = geometry.size.width / 15
                                let x = size * CGFloat(index % 15)
                                let y = size * CGFloat(index / 15)
                                path.addRect(CGRect(x: x, y: y, width: size, height: size))
                            }
                            .fill(squares[index])
                            .onTapGesture {
                                squares[index] = selectedColor
                            }
                        }
                    }
                    .frame(width: 160, height: 160)
                }
                
                TextField("Enter a bio", text: $bio)
                    .padding()
                    .border(Color.gray, width: 0.5)
                
                ColorPicker("Select a color", selection: $selectedColor)
                
                Button("Erase") {
                    selectedColor = .white
                }
                
                Button("Save") {
                    if let emblemIndex = emblemIndex {
                        emblems[emblemIndex].squares = squares.map { $0.description }
                    } else {
                        let newEmblem = Emblem(name: name, squares: squares.map { $0.description }, bio: bio)
                        emblems.append(newEmblem)
                        UserService().saveEmblem(emblem: newEmblem) { error in
                            if let error = error {
                                print("Error saving emblem: \(error)")
                            } else {
                                print("Emblem saved successfully")
                            }
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

    

