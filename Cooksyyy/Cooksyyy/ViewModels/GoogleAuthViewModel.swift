//
//  GoogleAuthViewModel.swift
//  Cooksyy
//
//  Created by Nxtwave on 17/09/25.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import Combine



@MainActor
final class GoogleAuthViewModel: ObservableObject {
    @Published var user: GIDGoogleUser?
    @Published var errorMessage: String?


    func signIn() async  {
        guard let presenter = UIApplication.topViewController else { return }

        do{
            // Explicit type annotation so Swift knows what T is
            let result: GIDSignInResult = try await withCheckedThrowingContinuation { (cont: CheckedContinuation<GIDSignInResult, Error>) in
                GIDSignIn.sharedInstance.signIn(withPresenting: presenter) { result, error in
                    if let error {
                        cont.resume(throwing: error)
                    } else if let result {
                        cont.resume(returning: result)
                    } else {
                        cont.resume(throwing: NSError(
                            domain: "GoogleSignIn",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Unknown sign-in error"]
                        ))
                    }
                }
            }

            self.user = result.user
            self.errorMessage = nil
        } catch let error as NSError {
            if error.code == -5 {
                // User cancelled sign-in
                self.errorMessage = "You cancelled Google Sign-In."
                print("User canceled sign-in.")
            } else {
                self.errorMessage = "Google Sign-In failed: \(error.localizedDescription)"
                print("Google Sign-In failed:", error)
            }
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        user = nil
    }

    var profile: (name: String, email: String, imageURL: URL?)? {
        guard let user else { return nil }
        return (user.profile?.name ?? "",
                user.profile?.email ?? "",
                user.profile?.imageURL(withDimension: 128))
    }

        }
