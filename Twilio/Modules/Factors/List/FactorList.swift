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
    @State var showCreateFactorView = false
    
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
    
    private func didTapAddFactor() {
        showCreateFactorView = true
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: CreateFactor(),
                           isActive: $showCreateFactorView) {
                EmptyView()
            }
            ActivityIndicator(isAnimating: $isLoading, style: .large)
            List(userInformation.containers) { container in
                NavigationLink(destination: ChallengesView(container: container)) {
                    FactorView(container: container)
                }
            }
        }.navigationTitle("Factors")
        .navigationBarItems(trailing:
            Button("Add", action: { self.didTapAddFactor() })
        )
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
