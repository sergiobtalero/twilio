//
//  SignInView.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 22/01/21.
//

import PromiseKit
import SwiftUI

struct SignInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var accessTokenEntity: AccessTokenEntity!
    @State private var userDidSignIn = false
    
    private func attemptToSignIn() {
        firstly {
            AuthService
                .login(name: username, password: password)
                .execute(object: LoginEntity.self)
        }.then { entity -> Promise<AccessTokenEntity> in
            AuthService.accessToken(id: entity.id)
                .execute(object: AccessTokenEntity.self)
        }.done { accessTokenEntity in
            self.accessTokenEntity = accessTokenEntity
            self.userDidSignIn = true
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NavigationLink(destination: FactorList(accessTokenEntity: accessTokenEntity),
                               isActive: $userDidSignIn) {
                    EmptyView()
                }
                Text("Username")
                    .font(.system(size: 20, weight: .bold))
                TextField("Enter username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                Text("Password")
                    .font(.system(size: 20, weight: .bold))
                TextField("Enter password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                HStack(alignment: .center) {
                    Spacer()
                    Button("Sign in") {
                        attemptToSignIn()
                    }.padding(.top, 40)
                    .disabled(username.isEmpty || password.isEmpty)
                    Spacer()
                }
            }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
