//
//  SignUpPageView.swift
//  Cooksyy
//
//  Created by Nxtwave on 01/09/25.
//

import SwiftUI
import  Combine
import GoogleSignIn
import GoogleSignInSwift

struct SignUpPageView: View {
    @EnvironmentObject var nameandpass: NameandPassword
    @State private var navigateToMain = false
    @State private var viewModel = GoogleAuthViewModel()
    @State private var googleSignInCancellable: AnyCancellable?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("cooksybg2")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    Text("Join the Feast 😋!")
                        .font(.system(size: 45, weight: .bold, design: .serif))
                        .foregroundStyle(.yellow.opacity(0.8))
                    Text("Create your new account")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding()

                    TextField(" ", text: $nameandpass.name,  prompt: Text("  👤     Full Name").foregroundColor(.white))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 60)
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(10)
                        .padding()
                    TextField(" ", text: $nameandpass.email, prompt: Text("  ✉️     user@gmail.com").foregroundColor(.white))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 60)
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(10)
                        .padding()
                    SecureField(" ", text: $nameandpass.password, prompt: Text("  🔒      Password").foregroundColor(.white))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 60)
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(10)
                        .padding()

                    Button {
                        navigateToMain = true
                    } label: {
                        Text("Login")
                            .font(.system(size: 25, weight: .bold, design: .monospaced))
                            .foregroundStyle(.white)
                            .frame(width: 300, height: 60)
                            .background(Color.black)
                            .cornerRadius(15)
                            .padding()
                    }

                    GoogleSignInButton{
                        Task{
                            await viewModel.signIn()
                        }
                    }
                    .frame(width: 280)
                    .cornerRadius(15)

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(Color.red)
                    }
                    
                    NavigationLink(destination: MainPage().environmentObject(nameandpass), isActive: $navigateToMain) {
                        EmptyView()
                    }
                    .hidden()

                    Spacer()
                    HStack{
                        Text("Already have an account?")
                            .foregroundColor(.white)
                            .bold()
                        NavigationLink(destination: SignInPageView().environmentObject(nameandpass)) {
                            Text("Sign In")
                                .foregroundColor(.blue)
                                .bold()
                                .underline()
                        }
                    }

                }
                .onAppear {
                    googleSignInCancellable = viewModel.$user.sink { user in
                        if user != nil {
                            navigateToMain = true
                        }
                    }
                }
                .onDisappear {
                    googleSignInCancellable = nil
                }

            }
        }
    }
}

#Preview {
    SignUpPageView()
        .environmentObject(NameandPassword())
}
