//
//  Ext DM Bunker Calc.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 08/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import CoreData
extension DataManager {
	
	func fetchEventsBunkerPerLocation (fetchedEvents : [Activity]) -> (hfoConsumption:[Double], mgoConsumption:[Double], hfoConsumptionAbsolute:[Double], mgoConsumptionAbsolute:[Double], boilerMultiplier : Double, ddggMultiplier : Double, meLabel : String, ddggLabel : String, boilerLabel : String,hfoConsumptionForHeader:[Double], mgoConsumptionForHeader:[Double]){
		
		
		var hfoArrayPerEvents : [Double] = []
		var mgoArrayPerEvents : [Double] = []
		var hfoArrayPerEventsForHeader : [Double] = []
		var mgoArrayPerEventsForHeader : [Double] = []
		var hfoArrayPerEventsAbsolute : [Double] = []
		var mgoArrayPerEventsAbsolute : [Double] = []
		var boilerMultiplierLabel : Double = 0
		var ddggMultiplierLabel : Double = 0
		var meLabel : String = ""
		var ddggLabel : String = ""
		var boilerLabel : String = ""
		
		if let bunkerCons = fetchBunkerConsumption()   {
			
			for t in fetchedEvents {
				var boilerHFOperEven : Double = 0
				var boilerMGOperEvent : Double = 0
				
				var ddggHFOperEvent : Double = 0
				var ddggMGOperEvent : Double = 0
				
				var meHFOperEvent : Double = 0
				var meMGOperEvent : Double = 0
				var seaPassageTime = 0.0
				if  t.distance > 0 && t.speed > 0 {
					let seaPassageTimeNoZero = (t.distance / t.speed)
					seaPassageTime = seaPassageTimeNoZero
				}
				let time = seaPassageTime + (t.duration/3600)
				
				var boilerMultiplier : Double = 0
				var ddggMultiplier : Double = 0
				
				let boilerConsuption = t.boilerConsuptionPerDay/24
				let ddGGConsuption = bunkerCons.ddggConsuption/24
				
				if t.isBoilerOne { boilerMultiplier += 1}
				if t.isBolierTwo { boilerMultiplier += 1}
				if t.isBolierThree { boilerMultiplier += 1}
				if t.isDDGG_One { ddggMultiplier += 1}
				if t.isDDGG_Two { ddggMultiplier += 1}
				if t.isDDGG_Three { ddggMultiplier += 1}
				
				
				if t.isBoilerHFO {
					boilerLabel = "HFO"
					boilerHFOperEven = ((boilerConsuption*boilerMultiplier)*time)
				} else {
					boilerLabel = "HFO"
					boilerMGOperEvent = ((boilerConsuption*boilerMultiplier)*time)
				}
				
				boilerMultiplierLabel = boilerMultiplier
				ddggMultiplierLabel = ddggMultiplier
				
				if t.isDDGG_Hfo {
					ddggLabel = "HFO"
					ddggHFOperEvent = ((ddGGConsuption*ddggMultiplier)*time)
				} else {
					ddggMGOperEvent = ((ddGGConsuption*ddggMultiplier)*time)
					ddggLabel = "MGO"
				}
				
				if t.isMaineEngine {
					let avgCons = bunkerDuringSeaPassage(speed: t.speed, vslLaddenPercentage: t.vslLaddenPercentage)/24
					
					if t.isMeHFO {
						meLabel = "HFO"
						meHFOperEvent = avgCons * time
					} else {
						meMGOperEvent = avgCons * time
						meLabel = "MGO"
					}
				}
				
				if t.fixedHFO > 0 {
					let hfoTotCons = t.fixedHFO
					hfoArrayPerEvents.append(hfoTotCons)
					hfoArrayPerEventsAbsolute.append(hfoTotCons)
				} else {
					let hfoTotCons = boilerHFOperEven + ddggHFOperEvent + meHFOperEvent - t.addHFO
					let hfoTotConsForHeader = boilerHFOperEven + ddggHFOperEvent + meHFOperEvent
					let hfoTotConsAbsolute = boilerHFOperEven + ddggHFOperEvent + meHFOperEvent
					hfoArrayPerEventsForHeader.append(hfoTotConsForHeader)
					hfoArrayPerEvents.append(hfoTotCons)
					hfoArrayPerEventsAbsolute.append(hfoTotConsAbsolute)
				}
				if t.fixedMGO > 0 {
					let mgoTotCons = t.fixedMGO
					mgoArrayPerEvents.append(mgoTotCons)
					mgoArrayPerEventsAbsolute.append(mgoTotCons)
				} else {
					let mgoTotCons = boilerMGOperEvent + ddggMGOperEvent + meMGOperEvent - t.addMGO
					let mgoTotConsForHeader = boilerMGOperEvent + ddggMGOperEvent + meMGOperEvent
					let mgoTotConsAbsolute = boilerMGOperEvent + ddggMGOperEvent + meMGOperEvent
					mgoArrayPerEventsForHeader.append(mgoTotConsForHeader)
					mgoArrayPerEvents.append(mgoTotCons)
					mgoArrayPerEventsAbsolute.append(mgoTotConsAbsolute)
				}
				
				
			}
			
		}
		return (hfoArrayPerEvents, mgoArrayPerEvents, hfoArrayPerEventsAbsolute, mgoArrayPerEventsAbsolute, boilerMultiplierLabel, ddggMultiplierLabel, meLabel : meLabel, ddggLabel : ddggLabel, boilerLabel : boilerLabel,hfoArrayPerEventsForHeader,mgoArrayPerEventsForHeader)
		
		
	}
	
	func deltaBunkerCalculatonPerLocations() -> (hfoConsumptionPerLoc:[Double], mgoConsumptionPerLoc:[Double]) {
		
		let allLoc = locationWithActivities()
		var hfoPerLocation : [Double] = []
		var mgoPerLocation : [Double] = []
		
		for (e) in allLoc {
			guard let ev = e.activity else { return ([], []) }
			let evs = ev.allObjects as! [Activity]
			
			let hfoPerPreviousSection = fetchEventsBunkerPerLocation(fetchedEvents: evs).hfoConsumption
			let mgoPerPreviousSection = fetchEventsBunkerPerLocation(fetchedEvents: evs).mgoConsumption
			let hfoSum = hfoPerPreviousSection.reduce(0, +)
			let mgoSum = mgoPerPreviousSection.reduce(0, +)
			hfoPerLocation.append(hfoSum)
			mgoPerLocation.append(mgoSum)
		}
		return (hfoPerLocation, mgoPerLocation)
	}
	
	// Used inside fetchEventsBunkerPerLocation
	func bunkerDuringSeaPassage (speed : Double, vslLaddenPercentage : Double) -> (Double){
		guard let b = fetchBunkerConsumption() else {
			return 0
		}
		if speed == 0 || speed > b.fullSpeed{
			let avgCons = (b.fullBallast + b.fullLadden)/2
			return avgCons
		}
		
		
		if (0..<b.forthySpeed).contains(speed) {
			let avgCons = b.forthyBallast + (((b.forthyLadden - b.forthyBallast)/100)*vslLaddenPercentage)
			return avgCons
		}
		
		if (b.forthySpeed..<b.sixtySpeed).contains(speed) {
			let speedDifference = b.sixtySpeed - b.forthySpeed
			let speedDelta = speed - b.forthySpeed
			let speedIndex = speedDelta/speedDifference
			
			let ConsBallastDifference = b.sixtyBallast - b.forthyBallast
			let deltaConsuptionInBallast = ConsBallastDifference * speedIndex
			let ConsInBallastAtSpeed = b.forthyBallast + deltaConsuptionInBallast
			
			let ConsLaddenDifference = b.sixtyLadden - b.forthyLadden
			let deltaConsuptionInLadden = ConsLaddenDifference * speedIndex
			let ConsInLaddenAtSpeed = b.forthyLadden + deltaConsuptionInLadden
			
			let avgCons = ConsInBallastAtSpeed + (((ConsInLaddenAtSpeed - ConsInBallastAtSpeed)/100)*vslLaddenPercentage)
			return avgCons
		}
		
		if (b.sixtySpeed..<b.eightySpeed).contains(speed) {
			let speedDifference = b.eightySpeed - b.sixtySpeed
			let speedDelta = speed - b.sixtySpeed
			let speedIndex = speedDelta/speedDifference
			
			let ConsBallastDifference = b.eightyBallast - b.sixtyBallast
			let deltaConsuptionInBallast = ConsBallastDifference * speedIndex
			let ConsInBallastAtSpeed = b.sixtyBallast + deltaConsuptionInBallast
			
			let ConsLaddenDifference = b.eightyLadden - b.sixtyLadden
			let deltaConsuptionInLadden = ConsLaddenDifference * speedIndex
			let ConsInLaddenAtSpeed = b.sixtyLadden + deltaConsuptionInLadden
			
			let avgCons = ConsInBallastAtSpeed + (((ConsInLaddenAtSpeed - ConsInBallastAtSpeed)/100)*vslLaddenPercentage)
			return avgCons
		}
		
		if (b.eightySpeed...b.fullSpeed).contains(speed) {
			let speedDifference = b.fullSpeed - b.eightySpeed
			let speedDelta = speed - b.eightySpeed
			let speedIndex = speedDelta/speedDifference
			
			let ConsBallastDifference = b.fullBallast - b.eightyBallast
			let deltaConsuptionInBallast = ConsBallastDifference * speedIndex
			let ConsInBallastAtSpeed = b.eightyBallast + deltaConsuptionInBallast
			
			let ConsLaddenDifference = b.fullLadden - b.eightyLadden
			let deltaConsuptionInLadden = ConsLaddenDifference * speedIndex
			let ConsInLaddenAtSpeed = b.eightyLadden + deltaConsuptionInLadden
			
			let avgCons = ConsInBallastAtSpeed + (((ConsInLaddenAtSpeed - ConsInBallastAtSpeed)/100)*vslLaddenPercentage)
			
			return avgCons
		}
		if speed > b.fullSpeed {
			return b.fullLadden
		}
		return 0
	}
}
