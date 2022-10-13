//
//  ContentView.swift
//  AppleLoginPractice
//
//  Created by Kim Insub on 2022/10/13.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""

    private var isSignedIn: Bool {
        !userId.isEmpty
    }

    var body: some View {
        VStack {
            if isSignedIn {
                Text("Welcome")
            } else {
                SignInButtonView()
            }
        }
    }
}

extension ContentView {
    @ViewBuilder
    func SignInButtonView() -> some View {
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                switch auth.credential {
                case let credential as ASAuthorizationAppleIDCredential:
                    let userId = credential.user
                    let email = credential.email
                    let firstName = credential.fullName?.givenName
                    let lastName = credential.fullName?.familyName

                    self.userId = userId
                    self.email = email ?? ""
                    self.firstName = firstName ?? ""
                    self.lastName = lastName ?? ""
                default:
                    break
                }
            case .failure(let error):
                print(error)
            }
        }
        .signInWithAppleButtonStyle(
            colorScheme == .dark ? .white : .black
        )
        .frame(height: 50)
        .padding()
        .cornerRadius(8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
