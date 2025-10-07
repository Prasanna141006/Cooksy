//
//  GetStartedPage.swift
//  Cooksyy
//
//  Created by Nxtwave on 01/09/25.
//

import SwiftUI
import Foundation

struct GetStartedPage: View {
    @StateObject private var nameandpass = NameandPassword()

    var body: some View {
        NavigationStack {
            ZStack {
                Image("cooksybg")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Make Your Own Food!")
                        .font(.system(size: 80, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 32)
                        .padding(.top, 32)
                    
                    Spacer()
                    NavigationLink(destination: SignInPageView().environmentObject(nameandpass)) {
                        Text("Sign In")
                            .font(.system(size: 30, weight: .bold, design: .monospaced))
                            .foregroundStyle(.white)
                            .frame(width: 300, height: 60)
                            .background(Color.mochacolor.opacity(0.8))
                            .cornerRadius(10)
                            .padding()
                    }

                    NavigationLink(destination: SignUpPageView().environmentObject(nameandpass)) {
                        Text("Get Started")
                            .font(.system(size: 30, weight: .bold, design: .monospaced))
                            .foregroundStyle(.white)
                            .frame(width: 300, height: 60)
                            .background(Color.mochacolor.opacity(0.8))
                            .cornerRadius(10)
                            .padding()
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    GetStartedPage()
}
