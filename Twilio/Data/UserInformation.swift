//
//  UserInformation.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 26/01/21.
//

import TwilioVerify
import Foundation

struct ChallengeContainer: Identifiable {
    let id: UUID
    let challenge: Challenge
    
    init(challenge: Challenge) {
        id = UUID()
        self.challenge = challenge
    }
}

struct FactorContainer: Identifiable {
    let id: UUID
    var factor: Factor
    var challenges: [ChallengeContainer] = []
    
    init(factor: Factor) {
        id = UUID()
        self.factor = factor
    }
}

final class UserInfomation: ObservableObject {
    @Published var accessTokenEntity: AccessTokenEntity?
    @Published var twilioVerify: TwilioVerify
    @Published var containers: [FactorContainer] = []
    
    init() {
        do {
            twilioVerify = try TwilioVerifyBuilder().build()
        } catch {
            fatalError("Could not load TwilioVerify")
        }
    }
}
