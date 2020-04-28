//
//  Distances+CoreDataClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Distances)
public class Distances: NSManagedObject {
	
	public var wrappedPlts : String{
		pilotStationComposit ?? "Unknown pltStn"
	}
	class func newDistances() -> Distances {
		
		return Distances(context: CoreData.stack.context)
	}
	
	class func createDistances(name: String, distance : Double,note: String) -> Distances {
		
		let distances = Distances.newDistances()
		distances.pilotStationComposit = name
		distances.idDistances = UUID()
		distances.distances = distance
		distances.voyNotes = note
		CoreData.stack.save()
		return distances
	}
	
	
}
