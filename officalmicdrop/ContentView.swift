//
//  ContentView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 5/23/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        VStack {
            Group {
                if viewModel.userSession == nil {
                    LoginView()
                    
                } else {
                    MainTabView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            
            
            ContentView()
        }
    }
}



