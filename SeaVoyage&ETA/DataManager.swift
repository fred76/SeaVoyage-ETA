//
//  DataManager.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import MapKit
class DataManager: NSObject {
	
	static let shared = DataManager()
	
	var activitiesClass : [ActivityClass] = []
	
	func fetchPortFromPLTs (pltName : String) -> (ports : [Ports], plt : PilotStations ) {
		
		let fetch = NSFetchRequest<PilotStations>(entityName: "PilotStations")
		fetch.predicate = NSPredicate(format: "pltName == %@", pltName)
		
		do {
			let pltS = try CoreData.stack.context.fetch(fetch) as [PilotStations]
			let plt = pltS.first 
			if let p = plt?.ports {
				let t = p.allObjects as! [Ports] 
				return (ports : t, plt : plt ?? PilotStations() )
			}
			
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		return(ports : [Ports()], plt : PilotStations() )
	}
	
	func fetchBerthFromPort (portName : String) -> (bert : [Berth], port : Ports ) {
		
		let fetch = NSFetchRequest<Ports>(entityName: "Ports")
		fetch.predicate = NSPredicate(format: "portName == %@", portName)
		
		do {
			let ports = try CoreData.stack.context.fetch(fetch) as [Ports]
			let port = ports.first
			
			if let p = port?.berth {
				let t = p.allObjects as! [Berth] 
				return (bert : t, port : port ?? Ports())
			}
			
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		return (bert : [Berth()], port : Ports() )
	}
	
	func fetchDistances(pltSToPltS : String)-> Distances?{
		let request = NSFetchRequest<Distances>(entityName: "Distances")
		request.predicate = NSPredicate(format: "pilotStationComposit == %@", pltSToPltS)
		
		do {
			let pltS = try CoreData.stack.context.fetch(request) as [Distances]
			return pltS.first
			
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		return  nil
		
	}
	
	func dismissKeyboard() {
		let keyWindow = UIApplication.shared.connectedScenes
			.filter({$0.activationState == .foregroundActive})
			.map({$0 as? UIWindowScene})
			.compactMap({$0})
			.first?.windows
			.filter({$0.isKeyWindow}).first
		keyWindow!.endEditing(true)
	}
	
}
