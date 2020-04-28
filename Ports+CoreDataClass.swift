//
//  Ports+CoreDataClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Ports)
public class Ports: NSManagedObject, Identifiable {
	
	public var wrappedPort : String{
		portName ?? "Unknown Port"
	}
	
	class func newPorts() -> Ports {
        
        return Ports(context: CoreData.stack.context)
    }
	
	
	
	public var berthsArray : [Berth] {
		let set = berth as? Set<Berth> ?? []
		return set.sorted {
			$0.wrappedBerth < $1.wrappedBerth
		}
	}
	
	class func createPorts(name: String) -> Ports {
		  
		let port = Ports.newPorts()
		port.portName = name
		port.id = UUID()
		CoreData.stack.save()
 
		  return port
	  }
	
	class func createPortFor(item: PilotStations, name: String) -> Ports {
        
		let port = Ports.newPorts()
		port.portName = name
		item.addToPorts(port)
		port.id = UUID()
        CoreData.stack.save()
        return port
    }
	
	class func deletePort() {
		
	}
}

