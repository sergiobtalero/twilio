//
//  FactorList.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 26/01/21.
//

import SwiftUI

struct FactorList: View {
    var accessTokenEntity: AccessTokenEntity?
    
    init(accessTokenEntity: AccessTokenEntity?) {
        self.accessTokenEntity = accessTokenEntity
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct FactorList_Previews: PreviewProvider {
    static var previews: some View {
        FactorList(accessTokenEntity: nil)
    }
}
