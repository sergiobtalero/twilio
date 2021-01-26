//
//  FactorView.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 26/01/21.
//

import TwilioVerify
import SwiftUI

struct FactorView: View {
    var container: FactorContainer
    
    private func getDateAsString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top) {
                Spacer()
                Text("\(container.factor.friendlyName)")
                    .font(.system(size: 18, weight: .heavy))
            }
            
            HStack(alignment: .top) {
                Text("SID:")
                    .font(.system(size: 15, weight: .light))
                Spacer()
                Text(container.factor.sid)
            }
            HStack(alignment: .top) {
                Text("Status:")
                    .font(.system(size: 15, weight: .light))
                Spacer()
                Text(container.factor.status.rawValue)
            }
            HStack(alignment: .top) {
                Text("Account SID:")
                    .font(.system(size: 15, weight: .light))
                Spacer()
                Text(container.factor.accountSid)
            }
            HStack(alignment: .top) {
                Text("Service SID:")
                    .font(.system(size: 15, weight: .light))
                Spacer()
                Text(container.factor.serviceSid)
            }
            HStack(alignment: .top) {
                Text("Identity:")
                    .font(.system(size: 15, weight: .light))
                Spacer()
                Text(container.factor.identity)
            }
            HStack(alignment: .top) {
                Text("Type:")
                    .font(.system(size: 15, weight: .light))
                Spacer()
                Text(container.factor.type.rawValue)
            }
            HStack(alignment: .top) {
                Text("Creation Date:")
                    .font(.system(size: 15, weight: .light))
                Spacer()
                Text(getDateAsString(from: container.factor.createdAt))
            }
        }
    }
}

struct FactorView_Previews: PreviewProvider {
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
        FactorView(container: container)
    }
}
