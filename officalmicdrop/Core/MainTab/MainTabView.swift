//  MainTabView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 5/23/23.
//

import SwiftUI

struct MainTabView: View {
    @State private var showNewTweetView = false
    @State private var showMenu: Bool = false
    @State private var selectedIndex: Int = 0
    @State private var users: [User] = []
    @State private var selectedFilter: FilterType = .following
    @State private var selectedDetailedFilter: DetailedFilter? = nil
    @State private var showFilterSheet: Bool = false
    @State private var shouldGoBack = false // Add this state variable

    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var headerVisible: Bool = true

    enum FilterType: String, CaseIterable {
        
        case following = "Following"
        case local = "Local"
    }

    enum DetailedFilter: String, CaseIterable {
        case highestRatedToday = "Highest Rated Today"
        case lowestRatedToday = "Lowest Rated Today"
        case mostRecent = "Most Recent"
        case mostTalkedAbout = "Most Talked About"
    }

    var body: some View {
        ZStack {
            VStack {
                // Header
                if selectedIndex == 0 {
                    VStack {
                        
                        Button(action: {
                            showFilterSheet = true
                        }) {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .imageScale(.large)
                                .foregroundColor(Color(red: 1.00, green: 0.84, blue: 0.00))  // RGB for Gold
                        }
                        
                        .padding(.leading)
                       
                        .sheet(isPresented: $showFilterSheet) {
                            VStack {
                                ForEach(DetailedFilter.allCases, id: \.self) { filter in
                                    Button(action: {
                                        selectedDetailedFilter = filter
                                        print("Selected filter: \(filter.rawValue)")
                                        // Implement the action for each filter here
                                        showFilterSheet = false
                                    }) {
                                        Text(filter.rawValue)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(filter == selectedDetailedFilter ? Color(red: 1.00, green: 0.84, blue: 0.00) : .black)
                                            .cornerRadius(10)
                                    }
                                    .padding()
                                }
                            }
                        }

                        HStack {
                            ForEach(FilterType.allCases, id: \.self) { filter in
                                Button(action: {
                                    withAnimation {
                                        selectedFilter = filter
                                    }
                                }) {
                                    Text(filter.rawValue)
                                        .font(.system(size: 14)) // Adjust the font size here.
                                        .padding(8) // Reduce the padding to make the square smaller.
                                        .foregroundColor(selectedFilter == filter ? .black : .gray)
                                        .background(selectedFilter == filter ? Color(red: 1.00, green: 0.84, blue: 0.00) : Color.clear)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding()
                    }
                    Divider()
                }
                
                
                // Main content
                switch selectedIndex {
                case 0:
                    NavigationView {
                        FeedView()
                    }
                case 1:
                    NavigationView {
                        if let currentUser = authViewModel.currentUser, let hashtagProfile = currentUser.hashtagProfile {
                            HashtagDetailView(authViewModel: authViewModel, hashtagProfile: hashtagProfile)
                        }
                    }
                case 2:
                    if let user = authViewModel.currentUser {
                        NavigationView {
                            Profileviews(user: user)
                        }
                    }
                default:
                    EmptyView()
                }
            }

            if showMenu {
                SemiCircleMenuView(showNewTweetView: $showNewTweetView, closeAction: {
                    withAnimation {
                        showMenu.toggle()
                    }
                })
            }
            
            VStack {
                Spacer()
                CustomTabBar(showMenu: $showMenu, selectedIndex: $selectedIndex)
            }
        }
        .fullScreenCover(isPresented: $showNewTweetView) {
            NewDropsView()
        }
        .onAppear {
            fetchUsers()
        }
    }
    
    func fetchUsers() {
        UserService().fetchUsers { fetchedUsers in
            users = fetchedUsers
            print("Fetched users: \(fetchedUsers)")
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView().environmentObject(AuthViewModel())
    }
}
