//
//  ExtensionDM Time Calc.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 08/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import CoreData

extension DataManager {
	func fetchEventsTimePerLocation (fetchedEvents : [Activity]) -> (timePerEvents:[Double], vslPercentage : String, cargoMT : String) {
		var timePerEvents : [Double] = []
		var vslPercentage : String = ""
		var cargoMT : String = ""
		for t in fetchedEvents {
			vslPercentage = String(format: "%.f", t.vslLaddenPercentage)
			cargoMT = String(format: "%.f", t.cargoMoved)
			var seaPassageTime = 0.0
			if  t.distance > 0 && t.speed > 0 {
				let seaPassageTimeNoZero = (t.distance / t.speed)*3600
				seaPassageTime = seaPassageTimeNoZero
			}
			let time = t.duration
			timePerEvents.append(seaPassageTime + time)
		}
		return (timePerEvents:timePerEvents, vslPercentage : vslPercentage, cargoMT : cargoMT)
	}
	
	func deltaTimeCalculatonPerLocations() -> [Double] {
		
		let loc = locationWithActivities()
		var allLocTime : [Double] = []
		for (e) in loc {
			guard let ev = e.activity else { return [] }
			let evs = ev.allObjects as! [Activity]
			
			let timePerPreviousSection = fetchEventsTimePerLocation(fetchedEvents: evs).timePerEvents
			
			let totalSum = timePerPreviousSection.reduce(0, +)
			
			allLocTime.append(totalSum)
		}
		
		return allLocTime
	}
	
	func fetchDeltaEventsTimePerLocation (fetchedEvents : LocationAndEvents) -> Double {
		var timePerEvents : [Double] = []
		guard let events = fetchedEvents.activity else {
			return 0
		}
		var e = events.allObjects as! [Activity]
		e.sort { (first: Activity, second: Activity ) -> Bool in first.eventID < second.eventID }
		
		for t in e {
			
			var seaPassageTime = 0.0
			if  t.distance > 0 && t.speed > 0 {
				let seaPassageTimeNoZero = (t.distance / t.speed)*3600
				seaPassageTime = seaPassageTimeNoZero
			}
			let time = t.duration
			timePerEvents.append(seaPassageTime + time)
		}
		let a = timePerEvents.reduce(0, +)
		return a
	}
}
