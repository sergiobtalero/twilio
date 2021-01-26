//
//  UserInformation.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 26/01/21.
//

import TwilioVerify
import Foundation

struct FactorContainer: Identifiable {
    let id: UUID
    var factor: Factor
    
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
