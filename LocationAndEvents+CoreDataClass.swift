//
//  LocationAndEvents+CoreDataClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(LocationAndEvents)
public class LocationAndEvents: NSManagedObject , Identifiable {
	/*
	@NSManaged public var locationName: String?
	@NSManaged public var locationID: Int16
	@NSManaged public var isLocationKind: Int16
	@NSManaged public var activity: NSSet?
	
	*/
	public var wrappedLocationAndEventsPort : String{
		port ?? "Unknown Port"
	}
	
	public var wrappedLocationAndEventsPltStn : String{
		pltStn ?? "Unknown PltStn"
	}
	
	public var wrappedLocationAndEventsBerth : String{
		berth ?? "Unknown PltStn"
	}
	
	public var activitiesArray : [Activity] {
		let set = activity as? Set<Activity> ?? []
		
		return set.sorted {
			$0.eventID < $1.eventID
		}
	}
	
	
	
	class func newLocationAndEvents() -> LocationAndEvents {
		
		return LocationAndEvents(context: CoreData.stack.context)
	}
	
	class func locationAndEventsCount() -> (Int){
		var locations : Int?
		var r : [LocationAndEvents] = []
		let fetchRequest = NSFetchRequest<LocationAndEvents>(entityName: "LocationAndEvents")
		let sort = NSSortDescriptor(key: #keyPath(LocationAndEvents.locationID), ascending: true)
		fetchRequest.sortDescriptors = [sort]
		
		do {
			let results = try CoreData.stack.context.fetch(fetchRequest)
			r = results
			locations = r.count
			
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		return (locations!)
	}
	
	class func createLocationAndEvents(pltStn: String,port: String,berth: String, timeZoneForLocation: Double) -> LocationAndEvents {
		let locationAndEvents = LocationAndEvents.newLocationAndEvents()
		locationAndEvents.locationID = Int16(locationAndEventsCount()-1)
		locationAndEvents.port = port
		locationAndEvents.pltStn = pltStn
		locationAndEvents.berth = berth
		locationAndEvents.timeZoneForLocation = timeZoneForLocation
		for (index, event) in DataManager.shared.activitiesClass.enumerated() {
			let act = Activity.createActivity(addHFO: event.addHFO,
											  addMGO: event.addMGO,
											  boilerConsuptionPerDay: event.boilerConsuptionPerDay,
											  cargoMoved: event.cargoMoved,
											  distance: event.distance,
											  duration: event.duration,
											  eventID: Int16(index),
											  fixedHFO: event.fixedHFO,
											  fixedMGO: event.fixedMGO,
											  isBoilerHFO: event.isBoilerHFO,
											  isBoilerOne: event.isBoilerOne,
											  isBolierThree: event.isBolierThree,
											  isBolierTwo: event.isBolierTwo,
											  isDDGG_Hfo: event.isDDGG_Hfo,
											  isDDGG_One: event.isDDGG_One,
											  isDDGG_Three: event.isDDGG_Three,
											  isDDGG_Two: event.isDDGG_Two,
											  isMaineEngine: event.isMaineEngine,
											  isMeHFO: event.isMeHFO,
											  speed: event.speed,
											  vslLaddenPercentage: event.vslLaddenPercentage,
											  berthOfActivity: event.berthOfShifting
				, acttivityCase: ActivityCase(rawValue: Int(event.isKindOf))!)
			locationAndEvents.addToActivity(act)
		}
		CoreData.stack.save()
		return locationAndEvents
	}
	
	class func addActivityToExsitingLocation(locationAndEvents: LocationAndEvents)  {
		let count = locationAndEvents.activitiesArray.count
		for (index, event) in DataManager.shared.activitiesClass.enumerated() {
			let act = Activity.createActivity(addHFO: event.addHFO,
											  addMGO: event.addMGO, 
											  boilerConsuptionPerDay: event.boilerConsuptionPerDay,
											  cargoMoved: event.cargoMoved, distance: event.distance, duration: event.duration,
											  eventID: Int16((count)+index),
											  fixedHFO: event.fixedHFO,
											  fixedMGO: event.fixedMGO,
											  isBoilerHFO: event.isBoilerHFO,
											  isBoilerOne: event.isBoilerOne,
											  isBolierThree: event.isBolierThree,
											  isBolierTwo: event.isBolierTwo,
											  isDDGG_Hfo: event.isBoilerOne,
											  isDDGG_One: event.isDDGG_One,
											  isDDGG_Three: event.isDDGG_Three,
											  isDDGG_Two: event.isDDGG_Two,
											  isMaineEngine: event.isMaineEngine,
											  isMeHFO: event.isMeHFO,
											  speed: event.speed,
											  vslLaddenPercentage: event.vslLaddenPercentage,
											  berthOfActivity: event.berthOfShifting
				, acttivityCase: ActivityCase(rawValue: Int(event.isKindOf))!)
			locationAndEvents.addToActivity(act)
		}
		CoreData.stack.save()
	}
	
	class func getAllLocationAndEvents() -> NSFetchRequest <LocationAndEvents> {
		let request = NSFetchRequest<LocationAndEvents>(entityName: "LocationAndEvents")
		let sortDescriptor = NSSortDescriptor(key: #keyPath(LocationAndEvents.locationID), ascending: true)
		request.sortDescriptors = [sortDescriptor]
		return request
	}
	
	
}
