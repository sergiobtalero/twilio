//
//  ChallengesView.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 26/01/21.
//

import TwilioVerify
import SwiftUI

struct ChallengesView: View {
    @EnvironmentObject var userInformation: UserInfomation
    
    @State var showAlert = false
    @State var container: FactorContainer
    @State var isLoading = false
    
    private func fetchChallenges() {
        isLoading = true
        let payload = ChallengeListPayload(factorSid: container.factor.sid,
                                           pageSize: 20,
                                           status: .pending)
        userInformation.twilioVerify
            .getAllChallenges(withPayload: payload, success: { object in
                self.isLoading = false
                let challenges = object.challenges.map { ChallengeContainer(challenge: $0) }
                container.challenges = challenges
            }, failure: { _ in
                self.isLoading = false
                self.showAlert = true
            })
    }
    
    func updateChallenge(challenge: Challenge) {
        let payload = UpdatePushChallengePayload(factorSid: challenge.factorSid,
                                                 challengeSid: challenge.sid,
                                                 status: .approved)
        userInformation.twilioVerify
            .updateChallenge(withPayload: payload, success: {
                self.fetchChallenges()
        }, failure: { error in
            print(error)
        })
    }
    
    private func getDateAsString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: date)
    }
    
    @ViewBuilder
    var challengesListView: some View {
        if container.challenges.isEmpty {
            emptyListView
        } else {
            challengestListView
        }
    }
    
    var emptyListView: some View {
        Text("No pending challenges")
    }
    
    var challengestListView: some View {
        List(container.challenges) { container in
            VStack(alignment: .leading, spacing: 5) {
                Text("Challenge")
                    .font(.system(size: 15, weight: .black))
                Text(container.challenge.challengeDetails.message)
                HStack(alignment: .top) {
                    Text("Created at:")
                        .font(.system(size: 15, weight: .light))
                    Spacer()
                    Text(getDateAsString(from: container.challenge.createdAt))
                }
                HStack {
                    Spacer()
                    Button("Accept Challenge") {
                        self.updateChallenge(challenge: container.challenge)
                    }
                    Spacer()
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            ActivityIndicator(isAnimating: $isLoading, style: .large)
            challengesListView
        }
        .navigationTitle("Pending Challenges")
        .onAppear {
            fetchChallenges()
        }
    }
    
    struct ChallengesView_Previews: PreviewProvider {
        static var container: FactorContainer {
            let factor = FactorMock(status: .unverified,
                                    sid: "sid",
                                    friendlyName: "friendlyName",
                                    accountSid: "accountSid",
                                    serviceSid: "serviceSid",
                                    identity: "identity",
                                    type: .push,
                                    createdAt: Date())
            return FactorContainer(factor: factor)
        }
        
        static var previews: some View {
            ChallengesView(container: container)
        }
    }
}
