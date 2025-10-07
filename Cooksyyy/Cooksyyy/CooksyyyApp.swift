//
//  CooksyyyApp.swift
//  Cooksyyy
//
//  Created by Nxtwave on 07/10/25.
//

import SwiftUI
import Combine
import GoogleSignIn
import GoogleSignInSwift
import UIKit




@main
struct CooksyyyApp: App {
    var body: some Scene {
        WindowGroup {
            GetStartedPage()
                .environmentObject(NameandPassword())
        }
    }
}


class NameandPassword: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isChecked: Bool = false
}

extension UIApplication {
  static var topViewController: UIViewController? {
    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController
    else { return nil }
    var top = root
    while let presented = top.presentedViewController {
      top = presented
    }
    return top
  }
}


