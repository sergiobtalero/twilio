//
//  AuthService.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 20/01/21.
//

import Foundation

struct LoginEntity: Codable {
    let id: String
    let redirect: String
}

struct AccessTokenEntity: Codable {
    let token: String
    let serviceSid: String
    let identity: String
    let factorType: String
}

enum AuthService {
    case login(name: String, password: String)
    case accessToken(id: String)
    case registerDevice(id: String, sid: String)
}

// MARK: - ServiceContract
extension AuthService: ServiceContract {
    var baseURL: String {
        return "http://localhost:5000/api"
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .accessToken:
            return "/devices/token"
        case .registerDevice:
            return "/devices/register"
        }
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: baseURL + path) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        httpBody.map { request.httpBody = $0 }
        
        return request
    }
    
    var httpBody: Data? {
        switch self {
        case let .login(name, password):
            let body = ["name": name,
                        "password": password]
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        case let .accessToken(id):
            let body = ["id": id]
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        case let .registerDevice(id, sid):
            let body = ["id": id,
                        "sid": sid]
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
    }
    
    var headers: [String: String]? {
        return ["content-type": "application/json"]
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .login, .accessToken, .registerDevice:
            return .post
        }
    }
}
