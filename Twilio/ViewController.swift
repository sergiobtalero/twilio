//
//  ViewController.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 20/01/21.
//

import TwilioVerify
import UIKit

class ViewController: UIViewController {
    private var twilioVerify: TwilioVerify?

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            twilioVerify = try TwilioVerifyBuilder().build()
            triggerAuthService()
        } catch {
            fatalError("Could not load TwilioVerify")
        }
    }
    
    func triggerAuthService() {
        AuthService.login(name: "covid", password: "covid")
            .execute(object: LoginEntity.self)
            .done({ loginEntity in
                self.useAccessTokenService(id: loginEntity.id)
            }).catch({ error in
                print(error)
            })
    }
    
    func useAccessTokenService(id: String) {
        AuthService.accessToken(id: id).execute(object: AccessTokenEntity.self)
            .done({ response in
                self.createAuthFactor(with: response)
            })
            .catch({ error in
                print(error)
            })
        
        
    }
    
    func createAuthFactor(with entity: AccessTokenEntity) {
        let dummyPushToken = "0000000000000000000000000000000000000000000000000000000000000000"
        let payload = PushFactorPayload(
            friendlyName: "friendlyName",
            serviceSid: entity.serviceSid,
            identity: entity.identity,
            pushToken: dummyPushToken,
            accessToken: entity.token
        )
        
        twilioVerify?.getAllFactors(success: { (factors) in
            for factor in factors {
                self.requestChallenges(with: factor)
            }
        }, failure: { (error) in
            print(error)
        })
        
//        twilioVerify?.createFactor(withPayload: payload, success: { [weak self] factor in
//            self?.verifyFactor(factor: factor)
//        }, failure: { error in
//            print(error)
//        })
    }
    
    func verifyFactor(factor: Factor) {
        let payload = VerifyPushFactorPayload(sid: factor.sid)
        twilioVerify?.verifyFactor(withPayload: payload, success: { [weak self] factor in
            self?.registerDevice(with: factor)
        }) { error in
          print(error)
        }
    }
    
    func registerDevice(with factor: Factor) {
        AuthService.registerDevice(id: factor.identity,sid: factor.sid)
            .execute()
            .done ({ response in
                self.requestChallenges(with: factor)
            }).catch({ error in
                print(error)
            })
    }
    
    func requestChallenges(with factor: Factor) {
        let payload = ChallengeListPayload(factorSid: factor.sid, pageSize: 20, status: .pending)
        twilioVerify?.getAllChallenges(withPayload: payload, success: { (list) in
            list.challenges.forEach { challenge in
                self.updateChallenge(challenge: challenge)
            }
        }, failure: { error in
            print(error)
        })
    }
    
    func updateChallenge(challenge: Challenge) {
        let payload = UpdatePushChallengePayload(factorSid: challenge.factorSid,
                                                 challengeSid: challenge.sid,
                                                 status: .approved)
        twilioVerify?.updateChallenge(withPayload: payload, success: {
            print("HOORAY")
        }, failure: { error in
            print(error)
        })
    }
}
