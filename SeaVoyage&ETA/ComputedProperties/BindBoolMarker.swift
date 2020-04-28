//
//  BindBoolMarker.swift
//  MyPortETA
//
//  Created by Alberto Lunardini on 09/03/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

func bindBool() -> Binding<Bool> {
	var boolVariable : Bool = true
	let boolVariableBinding : Binding<Bool> = Binding(get: { boolVariable }, set: { boolVariable = $0 })
	return boolVariableBinding
}

func bindDouble() -> Binding<Double> {
	var boolVariable : Double = 0
	let boolVariableBinding : Binding<Double> = Binding(get: { boolVariable }, set: { boolVariable = $0 })
	return boolVariableBinding
}

func bindAct() -> Binding<Activity?> {
	var boolVariable : Activity? = Activity()
	let boolVariableBinding : Binding<Activity?> = Binding(get: { (boolVariable ?? Activity()) }, set: { boolVariable = $0 })
	return boolVariableBinding
}

func bindLocationManager() -> Binding<CLLocationManager> {
	var boolVariable : CLLocationManager = CLLocationManager()
	let boolVariableBinding : Binding<CLLocationManager> = Binding(get: { boolVariable }, set: { boolVariable = $0 })
	return boolVariableBinding
}

func bindBerthDetail() -> Binding<BerthDetail?> {
	var boolVariable : BerthDetail? = BerthDetail()
	let boolVariableBinding : Binding<BerthDetail?> = Binding(get: { (boolVariable ?? BerthDetail()) }, set: { boolVariable = $0 })
	return boolVariableBinding
}
func bindBerthDetailNonOp() -> Binding<BerthDetail> {
	var boolVariable : BerthDetail = BerthDetail()
	let boolVariableBinding : Binding<BerthDetail> = Binding(get: { (boolVariable ) }, set: { boolVariable = $0 })
	return boolVariableBinding
}
func bindPilotStation() -> Binding<PilotStations> {
	var boolVariable : PilotStations = PilotStations()
	let boolVariableBinding : Binding<PilotStations> = Binding(get: { (boolVariable ) }, set: { boolVariable = $0 })
	return boolVariableBinding
}
func bindString() -> Binding<String> {
	var boolVariable : String = ""
	let boolVariableBinding : Binding<String> = Binding(get: { boolVariable }, set: { boolVariable = $0 })
	return boolVariableBinding
}
func bindBunkerDetail() -> Binding<BunkerVslDetails> {
	var boolVariable : BunkerVslDetails = BunkerVslDetails()
	let boolVariableBinding : Binding<BunkerVslDetails> = Binding(get: { (boolVariable ) }, set: { boolVariable = $0 })
	return boolVariableBinding
}
func bindBerth() -> Binding<Berth> {
	var boolVariable : Berth = Berth()
	let boolVariableBinding : Binding<Berth> = Binding(get: { (boolVariable ) }, set: { boolVariable = $0 })
	return boolVariableBinding
}


func bindStringConvert(myString : String) -> Binding<String> {
	var boolVariable : String = ""
	boolVariable = myString
	let boolVariableBinding : Binding<String> = Binding(get: { boolVariable }, set: { boolVariable = $0 })
	return boolVariableBinding
}
