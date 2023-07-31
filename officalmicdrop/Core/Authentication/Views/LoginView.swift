import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack {
                // Add your preferred background color here
                
                   
                VStack {
                    // header view
                    VStack(alignment: .leading) {
                        HStack { Spacer() }
                        
                        Text("Hello.")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            
                        Text("Welcome Back")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    .frame(height: 240)
                    .padding(.leading)
                    .background(Color(red: 1.00, green: 0.84, blue: 0.00))
                    .foregroundColor(.white)
                    .clipShape(RoundedShape(corners: (.bottomLeft)))
                    .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y: 0 )
                    
                    VStack(spacing: 40) {
                        CustomInputView(imageName:"envelope",
                                        placeholderText: "Email",
                                        text: $email)
                        
                        CustomInputView(imageName:"lock",
                                        placeholderText: "Password",
                                        text: $password, isSecureField: true)
                        
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 44)
                    
                    HStack {
                        Spacer()
                        NavigationLink {
                            Text("Reset password view..")
                        } label: {
                            Text("Forgot Password?")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(.black))
                                .padding(.trailing, 24)
                        }
                    }

                    Button {
                        viewModel.login(withEmail: email, password: password)
                    } label: {
                        Text("Sign in")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 340, height: 50)
                            .background(Color(.black))
                            .clipShape(Capsule())
                            .padding()
                    }
                    .shadow(color: .black.opacity(0.5), radius: 10, x:0, y: 0 )

                    Spacer()
                    

                    NavigationLink(destination: RegistrationView()) {
                        HStack {
                            Text("Dont have an account?")
                                .font(.footnote)
                        
                            Text("Sign Up")
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.bottom, 32)
                    .foregroundColor(Color(.black))
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

