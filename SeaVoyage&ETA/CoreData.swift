//
//  CoreData.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import CoreData

class CoreData: NSObject {
	
	static let stack = CoreData()
	
	// MARK: - Core Data stack
	
	private lazy var persistentContainer: NSPersistentContainer = {
		
		let container = NSPersistentCloudKitContainer(name: "Model")
		
		container.persistentStoreDescriptions.first?
			.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
		
		container.persistentStoreDescriptions.first?
			.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
		
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let nserror = error as NSError? {
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		})
		
		///# MODIFICA
		container.viewContext.name = "viewContext"
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		container.viewContext.automaticallyMergesChangesFromParent = false
		try? container.viewContext.setQueryGenerationFrom(.current)
		
// 		do {
//							print("""
//			pppp
//			p
//
//
//
//			p
//			""")
//						   try container.initializeCloudKitSchema(options: [.printSchema])
//								   // Uncomment to do a dry run and print the CK records it'll make
//			try container.initializeCloudKitSchema(options: [.dryRun, .printSchema])
//		 				 // Uncomment to initialize your schema
// 					  try container.initializeCloudKitSchema()
// 		} catch {
// 			print("Unable to initialize CloudKit schema: \(error.localizedDescription)")
// 	}
		
		return container
	}()
	
	public var context: NSManagedObjectContext {
		
		get {
			return self.persistentContainer.viewContext
		}
	}
	
	// MARK: - Core Data Saving support
	
	public func save() {
		
		if self.context.hasChanges {
			do {
				try self.context.save()
			} catch {
				
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	// MARK: - Database setup
	
	public class func initialDbSetup() -> Void {
		let pltStn = ["Maas Approach","steenbank", "Sea Waypoint", "Elbe"]
		let port = [["Rotterdam", "Europort", "Ruisbrok"],
					["Antwerp", "Flushing", "Emiksen"],
					["Seca Area South", "Seca Area North", "Europa Point"],
					["Brusbuttel", "Stade", "Hamburg"]]
		let berth = [
			[["Botlek", "Shell"], ["Caldic", "Kemihaven"],["Vopak", "Statoil"]],
			[["LBC", "Solvay"], ["Statoil", "OilTanking"],["Vopak #1", "Vesta"]],
			[["Inbound", "OutBound"], ["Inbound", "OutBound"],["East bound", "west bound"]],
			[["South Lock", "North Lock"], ["Dow Jetty 1", "Dow Jetty 1"],["Oiltankink", "Vopak"]]
		]
		if PilotStations.count() == 0 {
			for i in 0...3 {
				let newPltStn = PilotStations.createPilotStations(name: pltStn[i])
				for j in 0...2 {
					let p = Ports.createPorts(name: port[i][j])
					newPltStn.addToPorts(p)
					for h in 0...1 {
						let b = Berth.createBerth(name: berth[i][j][h])
						_ = BerthDetail.createBerthFor(item: b)
						p.addToBerth(b)
					}
				}
				
			}
		}
	}
	
	public class func initialDbSetupBunker() -> Void {
		if BunkerVslDetails.count() == 0 {
			_ = BunkerVslDetails.createBunkerVslDetails()
			
			CoreData.stack.save()
		}
	}
	
	public class func initialVesselData() -> Void {
		if VesselInitialSettings.count() == 0 {
			VesselInitialSettings.createVesselInitialSettings()
		}
	}
	
	// MARK: - Managed Object Helpers
	
	class func executeBlockAndCommit(_ block: @escaping () -> Void) {
		
		block()
		CoreData.stack.save()
	}
	
	
	
} 
