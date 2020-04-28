//
//  ExetensionDM_Bunker.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 07/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import CoreData

extension DataManager {
	func fetchBunkerConsumption() -> BunkerVslDetails? {
		var r : BunkerVslDetails!
		let fetchRequest = NSFetchRequest<BunkerVslDetails>(entityName: "BunkerVslDetails")
		let sortDate = NSSortDescriptor(key: "now", ascending: true)
		fetchRequest.sortDescriptors = [sortDate]
		do {
			let results = try CoreData.stack.context.fetch(fetchRequest)
			if let b = results.last {
				r = b
			}
			
			
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		return r
	}
	
	func RefreshBunkerConsumption() -> BunkerVslDetails {
		var r : BunkerVslDetails!
		let fetchRequest = NSFetchRequest<BunkerVslDetails>(entityName: "BunkerVslDetails")
		do {
			let results = try CoreData.stack.context.fetch(fetchRequest)
			for b in results {
				CoreData.stack.context.delete(b)
			}
			CoreData.stack.save()
			r = BunkerVslDetails.createBunkerVslDetails()
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		return r
	}
}
