//
//  Berth+CoreDataClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Berth)
public class Berth: NSManagedObject, Identifiable {
	public var wrappedBerth : String{
		berthName ?? "Unknown Port"
	}
	
	class func newBerth() -> Berth {
		
		return Berth(context: CoreData.stack.context)
	}
	
	class func createBerth(name: String) -> Berth {
		
		let berth = Berth.newBerth()
		berth.berthName = name
		berth.berthID = UUID()
		CoreData.stack.save()
		
		return berth
	}
	
	class func createBerthFor(item: Ports, name: String) -> Berth {
		
		let berth = Berth.newBerth()
		berth.berthName = name
		
		item.addToBerth(berth)
		berth.berthID = UUID()
		berth.port = item
		CoreData.stack.save()
		return berth
	}
	
	class func deletePort() {
		
	}
	
 
}
