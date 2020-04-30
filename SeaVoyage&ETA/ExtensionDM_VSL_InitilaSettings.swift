//
//  ExtensionDM_VSL_InitilaSettings.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 08/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import CoreData

extension DataManager {
	func fetchVesselInitialSettings() -> VesselInitialSettings? {
		var r : VesselInitialSettings!
		let fetchRequest = NSFetchRequest<VesselInitialSettings>(entityName: "VesselInitialSettings")
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
	
	func RefreshVesselInitialSettings() -> VesselInitialSettings {
		var r : VesselInitialSettings!
		let fetchRequest = NSFetchRequest<VesselInitialSettings>(entityName: "VesselInitialSettings")
		do {
			let results = try CoreData.stack.context.fetch(fetchRequest)
			for b in results {
				CoreData.stack.context.delete(b)
			}
			r = VesselInitialSettings.newVesselInitialSettings()
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		return r
	}
}
