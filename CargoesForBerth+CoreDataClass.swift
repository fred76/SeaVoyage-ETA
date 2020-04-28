//
//  CargoesForBerth+CoreDataClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CargoesForBerth)
public class CargoesForBerth: NSManagedObject {
	public var wrappedCargoName : String{
		cargoName ?? "Unknown cargo"
	}
	
	class func newCargoesForBerth() -> CargoesForBerth {
		
		return CargoesForBerth(context: CoreData.stack.context)
	}
	
	class func createCargoesForBerth(name: String) -> CargoesForBerth {
		
		let cargo = CargoesForBerth.newCargoesForBerth()
		 
		CoreData.stack.save()
		
		return cargo
	}
	
	class func createBerthFor(
		item: BerthDetail,
		cargoName: String,
		pumpingRate: Double,
		tankInspection: Int16,
		analyses: Int16,
		connectionArrangement: Int16,
		connectionSize: Double,
		analysesTime: Double,
	    wallWash: Int16,
		noteTxt: String
	
	) -> CargoesForBerth {
		
		let cargo = CargoesForBerth.newCargoesForBerth()
	  
		item.addToCargoesForBerths(cargo)
//		cargo.cargoID = UUID()
		cargo.berthDetails = item
		
		cargo.cargoName = cargoName
		cargo.pumpingRate = pumpingRate
		cargo.tankInspection = tankInspection
		cargo.analyses = analyses
		cargo.connectionArrangement = connectionArrangement
		cargo.connectionSize = connectionSize
		cargo.analysesTime = analysesTime
		cargo.wallWash = wallWash
		cargo.cargoNote = noteTxt
		CoreData.stack.save()
		return cargo
	}
	
	 
}


