//
//  SignInView.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 22/01/21.
//

import PromiseKit
import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userInformation: UserInfomation
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var userDidSignIn = false
    @State private var isLoading = false
    
    private func attemptToSignIn() {
        isLoading = true
        firstly {
            AuthService
                .login(name: username, password: password)
                .execute(object: LoginEntity.self)
        }.then { entity -> Promise<AccessTokenEntity> in
            AuthService.accessToken(id: entity.id)
                .execute(object: AccessTokenEntity.self)
        }.done { accessTokenEntity in
            self.userInformation.accessTokenEntity = accessTokenEntity
            self.userDidSignIn = true
        }.ensure {
            self.isLoading = false
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: FactorList(),
                                   isActive: $userDidSignIn) {
                        EmptyView()
                    }
                    Text("Username")
                        .font(.system(size: 20, weight: .bold))
                    TwilioTextField(text: $username, placeholderText: "Enter username")
                    Text("Password")
                        .font(.system(size: 20, weight: .bold))
                    TwilioTextField(text: $password, placeholderText: "Enter passwordd")
                    HStack(alignment: .center) {
                        Spacer()
                        Button("Sign in") {
                            attemptToSignIn()
                        }.padding(.top, 40)
                        .disabled(username.isEmpty || password.isEmpty)
                        Spacer()
                    }
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                ActivityIndicator(isAnimating: $isLoading, style: .large)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

struct TwilioTextField: View {
    @Binding var text: String
    var placeholderText: String
    
    var body: some View {
        TextField(placeholderText, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}
