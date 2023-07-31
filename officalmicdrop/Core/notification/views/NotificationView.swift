//
//  NotificationView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/13/23.
//

import SwiftUI

struct NotificationView: View {
    @State private var selectedTab: Tab = .main

    enum Tab {
        case main
        case label
        case hashtag
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            MainNotificationView()
                .tag(Tab.main)
                .tabItem {
                    Label("Main", systemImage: "bell")
                }

            LabelNotificationView()
                .tag(Tab.label)
                .tabItem {
                    Label("Label", systemImage: "tag")
                }

            HashtagNotificationView()
                .tag(Tab.hashtag)
                .tabItem {
                    Label("Hashtag", systemImage: "number")
                }
        }
    }
}

struct MainNotificationView: View {
    var body: some View {
        Text("Main Notifications")
    }
}

struct LabelNotificationView: View {
    var body: some View {
        Text("Label Notifications")
    }
}

struct HashtagNotificationView: View {
    var body: some View {
        Text("Hashtag Notifications")
    }
}

