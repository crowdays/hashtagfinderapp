//
//  RegistrationView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 5/30/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var hashcomponet = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            
            NavigationLink(destination: HashAndPhotoView(),
                           isActive: $viewModel.didAuthenticateUser, label: { })
            
            AuthenticationHeaderView(title1: "Get started.", title2: "Create your account")
            VStack (spacing: 40){
                
                CustomInputView(imageName:"envelope",
                                placeholderText: "Email",
                                text: $email)
                
                CustomInputView(imageName:"person",
                                placeholderText: "Username",
                                text: $username)
                
                CustomInputView(imageName:"person",
                                placeholderText: "Full name",
                                text: $fullname)
                
                
                CustomInputView(imageName:"lock",
                                placeholderText: "Password",
                                text: $password, isSecureField: true)
                
            }
            .padding(32)
            
            Button {
                viewModel.register(withEmail: email, password: password, fullname: fullname, username: username )
                
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(Color(.black))
                    .clipShape(Capsule())
                    .padding()
                
                
            }
            .shadow(color: .black.opacity(0.5), radius: 10, x:0, y: 0 )
            Spacer()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                        .font(.caption)
                    
                    Text("Sign In")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 32)
            .foregroundColor(Color(.black))
            
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
