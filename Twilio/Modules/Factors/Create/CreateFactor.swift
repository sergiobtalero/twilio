//
//  CreateFactor.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 26/01/21.
//

import TwilioVerify
import SwiftUI

struct CreateFactor: View {
    @EnvironmentObject var userInformation: UserInfomation
    @Environment(\.presentationMode) var presentation
    
    @State var showingAlert = false
    @State var factorName = ""
    @State var isLoading = false
    
    private func createFactor() {
        let dummyPushToken = "0000000000000000000000000000000000000000000000000000000000000000"
        guard let entity = userInformation.accessTokenEntity else {
            return
        }
        
        let payload = PushFactorPayload(
            friendlyName: factorName,
            serviceSid: entity.serviceSid,
            identity: entity.identity,
            pushToken: dummyPushToken,
            accessToken: entity.token
        )
        
        userInformation.twilioVerify.createFactor(withPayload: payload,
                                                  success: { factor in
            self.verifyFactor(factor: factor)
        }, failure: { _ in
            self.showingAlert = true
        })
    }
    
    private func verifyFactor(factor: Factor) {
        let payload = VerifyPushFactorPayload(sid: factor.sid)
        userInformation.twilioVerify.verifyFactor(withPayload: payload,
                                                  success: { factor in
            self.registerDevice(with: factor)
        }) { _ in
            self.showingAlert = true
        }
    }
    
    private func registerDevice(with factor: Factor) {
        AuthService.registerDevice(id: factor.identity, sid: factor.sid)
            .execute()
            .done({ _ in
                self.presentation.wrappedValue.dismiss()
            }).catch({ _ in
                self.showingAlert = true
            })
    }
    
    var body: some View {
        ZStack {
            ActivityIndicator(isAnimating: $isLoading, style: .large)
            VStack(alignment: .leading) {
                Text("Factor Name")
                    .font(.system(size: 20, weight: .bold))
                TwilioTextField(text: $factorName, placeholderText: "Enter Factor Name")
                HStack(alignment: .center) {
                    Spacer()
                    Button("Create") {
                        createFactor()
                    }.padding(.top, 40)
                    .disabled(factorName.isEmpty)
                    Spacer()
                }
            }.alert(isPresented: $showingAlert, content: {
                Alert(title: Text("Error"),
                      message: Text("Could not create factor"),
                      dismissButton: .default(Text("OK"))
                )
            })
            .navigationTitle("Create factor")
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
    }
}

struct CreateFactor_Previews: PreviewProvider {
    static var previews: some View {
        CreateFactor()
    }
}
