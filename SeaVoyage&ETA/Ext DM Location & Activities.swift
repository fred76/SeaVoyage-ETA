//
//  Ext DM Location & Activities.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 08/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import CoreData

extension DataManager {
	
	func locationWithActivities() -> [LocationAndEvents]  {
		var locAndEvs : [LocationAndEvents]!
		
		let fetch = NSFetchRequest<LocationAndEvents>(entityName: "LocationAndEvents")
		let sortDate = NSSortDescriptor(key: "locationID", ascending: true)
		fetch.sortDescriptors = [sortDate]
		do {
			let results = try CoreData.stack.context.fetch(fetch)
			
			
			locAndEvs = results
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		return locAndEvs
	}
	
	// Used inside ResultView
	func locationWithActivitiesMoveUp(section: Int) {
		let fetch = NSFetchRequest<LocationAndEvents>(entityName: "LocationAndEvents")
		let sortDate = NSSortDescriptor(key: "locationID", ascending: true)
		fetch.sortDescriptors = [sortDate]
		do {
			var loc = try CoreData.stack.context.fetch(fetch)
			if section == 0 {return}
			
			let l = loc[section]
			loc.remove(at: section)
			for i in stride(from: 0, to: loc.count, by: 1) {
				loc[i].locationID = Int16(i)
			}
			loc.insert(l, at: section-1)
			for i in stride(from: 0, to: loc.count, by: 1) {
				loc[i].locationID = Int16(i)
			}
			DispatchQueue.main.async {
				// now update UI on main thread
				
				if CoreData.stack.context.hasChanges {
					CoreData.stack.save()
				}
			}
			
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
	}
	
	func locationWithActivitiesMoveDown(section: Int) {
		let fetch = NSFetchRequest<LocationAndEvents>(entityName: "LocationAndEvents")
		let sortDate = NSSortDescriptor(key: "locationID", ascending: true)
		fetch.sortDescriptors = [sortDate]
		do {
			var loc = try CoreData.stack.context.fetch(fetch)
			
			if section == loc.count-1 {return}
			let l = loc[section]
			loc.remove(at: section)
			for i in stride(from: 0, to: loc.count, by: 1) {
				loc[i].locationID = Int16(i)
			}
			loc.insert(l, at: section+1)
			for i in stride(from: 0, to: loc.count, by: 1) {
				loc[i].locationID = Int16(i)
			}
			
			DispatchQueue.main.async {
				// now update UI on main thread
				
				if CoreData.stack.context.hasChanges {
					CoreData.stack.save()
				}
			}
			
			
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
	}
	
	func setIDforLocationAndEvents()  {
		
		let fetch = NSFetchRequest<LocationAndEvents>(entityName: "LocationAndEvents")
		let sortDate = NSSortDescriptor(key: "locationID", ascending: true)
		fetch.sortDescriptors = [sortDate]
		do {
			let results = try CoreData.stack.context.fetch(fetch)
			for (i,e) in results.enumerated(){
				e.locationID = Int16(i+1)
			}
			CoreData.stack.save()
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
	}
	
}
