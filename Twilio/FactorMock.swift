//
//  FactorMock.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 26/01/21.
//

import TwilioVerify
import Foundation

struct FactorMock: Factor {
    var status: FactorStatus
    var sid: String
    var friendlyName: String
    var accountSid: String
    var serviceSid: String
    var identity: String
    var type: FactorType
    var createdAt: Date
}
