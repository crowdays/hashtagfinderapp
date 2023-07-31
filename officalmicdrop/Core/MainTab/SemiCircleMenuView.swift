//
//  SemiCircleMenuView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 7/20/23.
//

import SwiftUI

struct SemiCircleMenuView: View {
    @State private var angle: Angle = .degrees(0)
    @State private var velocity: Double = 0
    @State private var lastDragValue: Angle?
    @State private var showProfileviews: Bool = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showNewTweetView: Bool
    
    private let decayRate: Double = 0.99
    private let timer = Timer.publish(every: 0.08, on: .main, in: .common).autoconnect()
    
    var closeAction: () -> Void

    private let buttons: [(name: String, offset: (x: CGFloat, y: CGFloat), rotation: Double)] = [
        ("plus.circle.fill", (x: -15, y: -100), 0),
        ("person.crop.circle", (x: -70, y: -70), 0),
        ("magnifyingglass.circle", (x: -95, y: -20), 0),
        ("crown", (x: -75, y: 30), 0),
        ("gearshape", (x: 45, y: 30), 0),
        ("number.square", (x: -15, y: 55), 0),
        ("bell", (x: 35, y: -75), 0),
        ("envelope", (x: 60, y: -20), 0)
    ]
    
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    createCircleGesture(geometry: geometry)
                    createCircleView()
                    createButtons(geometry: geometry)
                    createCloseButton()
                }
                .rotationEffect(-self.angle)
                .padding()
                .background(
                    Circle()
                        .foregroundColor(Color.black.opacity(1))
                        .frame(width: 250, height: 120)
                )
                .offset(y: 370)
                .onReceive(timer) { _ in
                    self.angle = Angle(radians: self.angle.radians + self.velocity)
                    self.velocity *= self.decayRate
                }
            }
            .padding(.horizontal)
            .background(Color.clear)
        }

        // Circle view with gesture
        func createCircleGesture(geometry: GeometryProxy) -> some View {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(Color.clear)
                .contentShape(Circle())
                .gesture(
                    DragGesture(minimumDistance: 5)
                        .onChanged {
                            value in
                            let angle = angle(for: value.location, in: geometry.size)
                            if let lastDragValue = self.lastDragValue {
                                let delta = shortestAngle(from: lastDragValue.radians, to: angle.radians)
                                self.velocity = delta / 0.09 // Assuming 0.01 is your time step
                            }
                            self.lastDragValue = angle
                        }
                        .onEnded { _ in
                            self.lastDragValue = nil
                        }
                )
        }

        // Circle view with stroke
        func createCircleView() -> some View {
            Circle()
                .stroke(Color.black, lineWidth: 2)
                .frame(width: 200, height: 200)
        }

    // Create buttons
    func createButtons(geometry: GeometryProxy) -> some View {
        ForEach(buttons, id: \.name) { button in
            if button.name == "person.crop.circle" {
                if let user = authViewModel.currentUser {
                    NavigationLink(destination: Profileviews(user: user)) {
                        Image(systemName: button.name)
                            .imageScale(.large)
                            .foregroundColor(.gray)
                            .rotationEffect(Angle(degrees: button.rotation))
                    }
                    .position(x: geometry.size.width / 2 + button.offset.x, y: geometry.size.height / 2 + button.offset.y)
                }
            } else if button.name == "plus.circle.fill" {
                Button(action: {
                    showNewTweetView = true
                }) {
                    Image(systemName: button.name)
                        .imageScale(.large)
                    
                        .foregroundColor(.gray)
                        .rotationEffect(Angle(degrees: button.rotation))
                }
                .position(x: geometry.size.width / 2 + button.offset.x, y: geometry.size.height / 2 + button.offset.y)
            } else if button.name == "gearshape" {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: button.name)
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .rotationEffect(Angle(degrees: button.rotation))
                }
                .position(x: geometry.size.width / 2 + button.offset.x, y: geometry.size.height / 2 + button.offset.y)
            } else if button.name == "person.crop.circle" {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: button.name)
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .rotationEffect(Angle(degrees: button.rotation))
                }
                .position(x: geometry.size.width / 2 + button.offset.x, y: geometry.size.height / 2 + button.offset.y)
            } else if button.name == "magnifyingglass.circle" {
                NavigationLink(destination: ExploreView()) {
                    Image(systemName: button.name)
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .rotationEffect(Angle(degrees: button.rotation))
                }
                .position(x: geometry.size.width / 2 + button.offset.x, y: geometry.size.height / 2 + button.offset.y)
                
            } else if button.name == "bell" {
                NavigationLink(destination: NotificationView()) {
                    Image(systemName: button.name)
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .rotationEffect(Angle(degrees: button.rotation))
                }
                .position(x: geometry.size.width / 2 + button.offset.x, y: geometry.size.height / 2 + button.offset.y)
                
            } else if button.name == "crown" {
                NavigationLink(destination: EmblemListView()) {
                    Image(systemName: button.name)
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .rotationEffect(Angle(degrees: button.rotation))
                }
                .position(x: geometry.size.width / 2 + button.offset.x, y: geometry.size.height / 2 + button.offset.y)
                
                
                
            } else {
                Button(action: {
                    print(button.name)
                }) {
                    Image(systemName: button.name)
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .rotationEffect(Angle(degrees: button.rotation))
                }
                .position(x: geometry.size.width / 2 + button.offset.x, y: geometry.size.height / 2 + button.offset.y)
            }
        }
    }


        // Create Close button
        func createCloseButton() -> some View {
            Button(action: closeAction, label: {
                Image(systemName: "x.circle")
                    .imageScale(.large)
                    .foregroundColor(.red)
            })
        }

        private func angle(for point: CGPoint, in size: CGSize) -> Angle {
            let vector = CGVector(dx: point.x - size.width / 2, dy: size.height / 2 - point.y)
            return Angle(radians: Double(atan2(vector.dy, vector.dx)))
        }

        private func shortestAngle(from: Double, to: Double) -> Double {
            let twoPi = 2 * Double.pi
            var delta = (to - from).truncatingRemainder(dividingBy: twoPi)
            delta = (delta + twoPi).truncatingRemainder(dividingBy: twoPi)
            if delta > Double.pi {
                delta -= twoPi
            }
            return delta
        }
    }
struct SemiCircleMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SemiCircleMenuView(showNewTweetView: .constant(false), closeAction: {})
    }
}


