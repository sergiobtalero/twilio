//
//  SceneDelegate.swift
//  Twilio
//
//  Created by Sergio David Bravo Talero on 20/01/21.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            fatalError("Could not load scene")
        }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: SignInView())
        self.window = window
        window.makeKeyAndVisible()
    }
}
