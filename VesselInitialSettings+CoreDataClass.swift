//
//  VesselInitialSettings+CoreDataClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VesselInitialSettings)
public class VesselInitialSettings: NSManagedObject, Identifiable {
	
	class func newVesselInitialSettings() -> VesselInitialSettings {
		
		return VesselInitialSettings(context: CoreData.stack.context)
	}
	
	class func count() -> Int {
		
		let fetchRequest: NSFetchRequest<VesselInitialSettings> = VesselInitialSettings.fetchRequest()
		
		do {
			let count = try CoreData.stack.context.count(for: fetchRequest)
			return count
		} catch let error as NSError {
			fatalError("Unresolved error \(error), \(error.userInfo)")
		}
	}
	
	class func createVesselInitialSettings() {
		
		let vesselInitialSettings = VesselInitialSettings.newVesselInitialSettings()
		vesselInitialSettings.initialHFO = "0"
		vesselInitialSettings.initialMGO = "0"
		vesselInitialSettings.initialDate = "01/01/2020 0001"
		vesselInitialSettings.timeZoneFromSetting = 0.0
		CoreData.stack.save()
		 
	}
 
}
