//
//  SettingsView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/3/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authviewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            Picker(selection: $selectedTab, label: Text("Settings")) {
                Text("Account").tag(0)
                Text("Notifications").tag(1)
                Text("Bug Report").tag(2)
                Text("Blocked People").tag(3)
                Text("Language").tag(4)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedTab == 0 {
                AccountSettingsView()
            } else if selectedTab == 1 {
                NotificationSettingsView()
            } else if selectedTab == 2 {
                BugReportView()
            } else if selectedTab == 3 {
                BlockedPeopleView()
            } else if selectedTab == 4 {
                LanguageSettingsView()
            }
            
            Spacer()
            
            Button(action: {
                authviewModel.signOut()
            }) {
                Text("Log Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(15)
            }
            .padding()
        }
    }
}

struct AccountSettingsView: View {
    var body: some View {
        Text("Account settings go here")
    }
}

struct NotificationSettingsView: View {
    var body: some View {
        Text("Notification settings go here")
    }
}

struct BugReportView: View {
    var body: some View {
        Text("Bug reporting goes here")
    }
}

struct BlockedPeopleView: View {
    var body: some View {
        Text("Blocked people management goes here")
    }
}

struct LanguageSettingsView: View {
    var body: some View {
        Text("Language settings go here")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
