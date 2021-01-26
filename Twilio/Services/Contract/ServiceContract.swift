//
//  ServiceContract.swift
//  Data
//
//  Created by Sergio David Bravo Talero on 18/01/21.
//

import Foundation
import PromiseKit

typealias URLSessionResponse = (Data?, URLResponse?, Error?) -> Void

public enum APINetworkError: Error {
    case invalidURL
    case badResponse
    case invalidData
    case invalidRequest
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol ServiceContract {
    var baseURL: String { get }
    var path: String { get }
    var urlRequest: URLRequest? { get }
    var httpBody: Data? { get }
    var headers: [String: String]? { get }
    var httpMethod: HttpMethod { get }
    
    func execute<T: Codable>(session: URLSession, object: T.Type) -> Promise<T>
}

extension ServiceContract {
    func execute<T: Codable>(session: URLSession = URLSession.shared, object: T.Type) -> Promise<T> {
        Promise { seal in
            guard let request = self.urlRequest else {
                seal.reject(APINetworkError.invalidRequest)
                return
            }
            
            let task = session.dataTask(with: request) { (data, _, error) in
                if error != nil {
                    seal.reject(APINetworkError.badResponse)
                    return
                }
                guard let data = data else {
                    seal.reject(APINetworkError.invalidData)
                    return
                }
                if let objects = try? JSONDecoder().decode(T.self, from: data) {
                    seal.fulfill(objects)
                } else {
                    seal.reject(APINetworkError.badResponse)
                }
            }
            task.resume()
        }
    }
    
    func execute(session: URLSession = URLSession.shared) -> Promise<[String: Any]?> {
        Promise { seal in
            guard let request = self.urlRequest else {
                seal.reject(APINetworkError.invalidRequest)
                return
            }
            
            let task = session.dataTask(with: request) { (data, _, error) in
                if error != nil {
                    seal.reject(APINetworkError.badResponse)
                    return
                }
                guard let data = data else {
                    seal.reject(APINetworkError.invalidData)
                    return
                }
                guard let dictionary = try? JSONSerialization
                        .jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    seal.reject(APINetworkError.badResponse)
                    return
                }
                seal.fulfill(dictionary)
            }
            task.resume()
        }
    }
}
