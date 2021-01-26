//
//  FactorList.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 26/01/21.
//

import TwilioVerify
import SwiftUI

struct FactorList: View {
    @EnvironmentObject var userInformation: UserInfomation
    @State var error: TwilioVerifyError?
    @State var isLoading = false
    
    private func getFactorsList() {
        isLoading = true
        userInformation.twilioVerify.getAllFactors { factors in
            let containers = factors.map { FactorContainer(factor: $0) }
            self.userInformation.containers = containers
            self.isLoading = false
        } failure: { error in
            self.error = error
            self.isLoading = false
        }

    }
    
    var body: some View {
        ZStack {
            ActivityIndicator(isAnimating: $isLoading, style: .large)
            List(userInformation.containers) { container in
                Text("Factor \(container.factor.accountSid)")
            }
        }.navigationTitle("Factors")
        .onAppear {
            getFactorsList()
        }
    }
}

struct FactorList_Previews: PreviewProvider {
    static var previews: some View {
        FactorList()
    }
}
