//
//  ActivityClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation

class ActivityClass: NSObject {
	
	internal init(addHFO: Double, addMGO: Double, boilerConsuptionPerDay: Double, cargoMoved: Double, distance: Double, duration: Double, eventID: Int16, fixedHFO: Double, fixedMGO: Double, isBoilerHFO: Bool, isBoilerOne: Bool, isBolierThree: Bool, isBolierTwo: Bool, isDDGG_Hfo: Bool, isDDGG_One: Bool, isDDGG_Three: Bool, isDDGG_Two: Bool, isMaineEngine: Bool, isMeHFO: Bool, speed: Double, vslLaddenPercentage: Double, isKindOf: Int16, berthOfShifting :String )
	{
		self.addHFO = addHFO
		self.addMGO = addMGO
		self.boilerConsuptionPerDay = boilerConsuptionPerDay
		self.cargoMoved = cargoMoved
		self.distance = distance
		self.duration = duration
		self.eventID = eventID
		self.fixedHFO = fixedHFO
		self.fixedMGO = fixedMGO
		self.isBoilerHFO = isBoilerHFO
		self.isBoilerOne = isBoilerOne
		self.isBolierThree = isBolierThree
		self.isBolierTwo = isBolierTwo
		self.isDDGG_Hfo = isDDGG_Hfo
		self.isDDGG_One = isDDGG_One
		self.isDDGG_Three = isDDGG_Three
		self.isDDGG_Two = isDDGG_Two
		self.isMaineEngine = isMaineEngine
		self.isMeHFO = isMeHFO
		self.speed = speed
		self.vslLaddenPercentage = vslLaddenPercentage
		self.berthOfShifting = berthOfShifting
		self.isKindOf = isKindOf
	}
	
	
	
	var addHFO: Double
	var addMGO: Double
	var boilerConsuptionPerDay: Double
	var cargoMoved: Double
	var distance: Double
	var duration: Double
	var eventID: Int16
	var fixedHFO: Double
	var fixedMGO: Double
	var isBoilerHFO: Bool
	var isBoilerOne: Bool
	var isBolierThree: Bool
	var isBolierTwo: Bool
	var isDDGG_Hfo: Bool
	var isDDGG_One: Bool
	var isDDGG_Three: Bool
	var isDDGG_Two: Bool
	var isMaineEngine: Bool
	var isMeHFO: Bool
	var speed: Double
	var vslLaddenPercentage: Double
	var berthOfShifting: String
	var isKindOf: Int16 
}
