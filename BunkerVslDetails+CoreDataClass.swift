//
//  BunkerVslDetails+CoreDataClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI
@objc(BunkerVslDetails)
public class BunkerVslDetails: NSManagedObject, Identifiable {
	
	class func newBunkerVslDetails() -> BunkerVslDetails {
		
		return BunkerVslDetails(context: CoreData.stack.context)
	}
	
	class func createBunkerVslDetails() -> BunkerVslDetails {
		let bunkerVslDetails = BunkerVslDetails.newBunkerVslDetails()
		CoreData.stack.save()
		return bunkerVslDetails
	}
	
	class func count() -> Int {
		
		let fetchRequest: NSFetchRequest<BunkerVslDetails> = BunkerVslDetails.fetchRequest()
		
		do {
			let count = try CoreData.stack.context.count(for: fetchRequest)
			return count
		} catch let error as NSError {
			fatalError("Unresolved error \(error), \(error.userInfo)")
		}
	}
	
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
	
}
