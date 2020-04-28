//
//  PilotStations+CoreDataClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI
@objc(PilotStations)
public class PilotStations: NSManagedObject, Identifiable {
	 
	
	public var wrappedPlts : String{
		pltName ?? "Unknown Port"
	}
	
	public var portsArray : [Ports] {
		let set = ports as? Set<Ports> ?? []
		return set.sorted {
			$0.wrappedPort < $1.wrappedPort
		}
	}
	
	 
	
	
	
	class func count() -> Int {
		
		let fetchRequest: NSFetchRequest<PilotStations> = PilotStations.fetchRequest()
		
		do {
			let count = try CoreData.stack.context.count(for: fetchRequest)
			return count
		} catch let error as NSError {
			fatalError("Unresolved error \(error), \(error.userInfo)")
		}
	}
	
	class func newPilotStations() -> PilotStations {
		
		return PilotStations(context: CoreData.stack.context)
	}
	
	class func createPilotStations(name: String ) -> PilotStations {
		
		let pltStation = PilotStations.newPilotStations()
		pltStation.pltName = name
		pltStation.idPLT = UUID()
		CoreData.stack.save()
		return pltStation
	}
	
 
}
