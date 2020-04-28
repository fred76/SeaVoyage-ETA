//
//  SceneDelegate.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		let contentView = ContentView()
		
		// Use a UIHostingController as window root view controller.
		if let windowScene = scene as? UIWindowScene {
			let context = CoreData.stack.context
			let window = UIWindow(windowScene: windowScene)
			window.rootViewController = UIHostingController(rootView: contentView
				.environment(\.managedObjectContext, context)
				.environmentObject(UserEnvironment())
			)
			context.automaticallyMergesChangesFromParent = true
			self.window = window
			window.makeKeyAndVisible()
		}
	}
	
	func sceneDidDisconnect(_ scene: UIScene) {
	}
	
	func sceneDidBecomeActive(_ scene: UIScene) {
	}
	
	func sceneWillResignActive(_ scene: UIScene) {
	}
	
	func sceneWillEnterForeground(_ scene: UIScene) {
	}
	
	func sceneDidEnterBackground(_ scene: UIScene) { 
	}
	
	
}

import Foundation
import SwiftUI

class UserEnvironment: ObservableObject {
	
}
