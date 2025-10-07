//
//  SignInPageView.swift
//  Cooksyy
//
//  Created by Nxtwave on 03/09/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Combine

struct SignInPageView: View {
    @EnvironmentObject var nameandpass: NameandPassword
    @State private var navigateToMain = false
    @State private var viewModel = GoogleAuthViewModel()
    
    @State private var googleSignInCancellable: AnyCancellable?

    var body: some View {
        NavigationStack {
            ZStack{
                Image("cooksybg4")
                    .resizable()
                    .ignoresSafeArea(edges: .all)
                    

                VStack{
                    Spacer()
                    Text("The Kitchen Missed You 👨‍🍳💛!")
                        .bold()
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundStyle(.yellow)
                        .padding(.bottom, 10)
                    Text("Login back to your account!")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundStyle(.black.opacity(0.8))
                    TextField(" ", text: $nameandpass.name,  prompt: Text("  👤     Full Name").foregroundColor(.white))
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

                    HStack(alignment: .top){
                        Button {
                            nameandpass.isChecked.toggle()
                        } label: {
                            Image(systemName: nameandpass.isChecked ? "checkmark.square.fill" : "square")
                                .foregroundStyle(nameandpass.isChecked ? .blue : .black)
                        }
                        Text("Remember Me")
                            .foregroundStyle(.black)
                            .bold()

                        Text("Forgot Password?")
                            .underline()
                            .foregroundStyle(.black)
                            .bold()
                            .padding()
                    }
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

                    if let errorMessage = viewModel.errorMessage{
                        Text(errorMessage)
                            .foregroundStyle(Color.red)
                    }

                    NavigationLink(destination: MainPage().environmentObject(nameandpass), isActive: $navigateToMain) {
                        EmptyView()
                    }
                    .hidden()
                    Spacer()
                    HStack{
                        Text("Don't have an account?")
                            .foregroundStyle(.black)
                            .bold()
                        NavigationLink(destination: SignUpPageView().environmentObject(nameandpass)) {
                            Text("Sign Up")
                                .bold()
                                .foregroundStyle(.blue)
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
    SignInPageView()
        .environmentObject(NameandPassword())
}
