//
//  Activity+CoreDataClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData
import Combine
@objc(Activity)
public class Activity: NSManagedObject, Identifiable {
	
	
	class func newActivity() -> Activity {
		
		return Activity(context: CoreData.stack.context)
	}
	
	class func createActivity(addHFO: Double,
							  addMGO: Double,
							  boilerConsuptionPerDay: Double,
							  cargoMoved: Double,
							  distance: Double,
							  duration: Double,
							  eventID: Int16,
							  fixedHFO: Double,
							  fixedMGO: Double,
							  isBoilerHFO: Bool,
							  isBoilerOne: Bool,
							  isBolierThree: Bool,
							  isBolierTwo: Bool,
							  isDDGG_Hfo: Bool,
							  isDDGG_One: Bool,
							  isDDGG_Three: Bool,
							  isDDGG_Two: Bool,
							  isMaineEngine: Bool,
							  isMeHFO: Bool,
							  speed: Double,
							  vslLaddenPercentage: Double,
							  berthOfActivity: String,
							  acttivityCase : ActivityCase
	) -> Activity {
		
		let activity = Activity.newActivity()
		activity.addHFO = addHFO
		activity.addMGO = addMGO
		activity.boilerConsuptionPerDay = boilerConsuptionPerDay
		activity.cargoMoved = cargoMoved
		activity.distance = distance
		activity.duration = duration
		activity.eventID = eventID
		activity.fixedHFO = fixedHFO
		activity.fixedMGO = fixedMGO
		activity.isBoilerHFO = isBoilerHFO
		activity.isBoilerOne = isBoilerOne
		activity.isBolierThree = isBolierThree
		activity.isBolierTwo = isBolierTwo
		activity.isDDGG_Hfo = isDDGG_Hfo
		activity.isDDGG_One = isDDGG_One
		activity.isDDGG_Three = isDDGG_Three
		activity.isDDGG_Two = isDDGG_Two
		activity.isMaineEngine = isMaineEngine
		activity.isMeHFO = isMeHFO
		activity.speed = speed
		activity.vslLaddenPercentage = vslLaddenPercentage
		activity.berthOfActivity = berthOfActivity
		activity.isKindOf = Int16(acttivityCase.rawValue) 
		CoreData.stack.save()
		return activity
		
	}
	
}
