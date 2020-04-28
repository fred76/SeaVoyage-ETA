//
//  Ports+CoreDataProperties.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension Ports {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ports> {
        return NSFetchRequest<Ports>(entityName: "Ports")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var portName: String?
    @NSManaged public var berth: NSSet?
    @NSManaged public var pilotStations: PilotStations?

}

// MARK: Generated accessors for berth
extension Ports {

    @objc(addBerthObject:)
    @NSManaged public func addToBerth(_ value: Berth)

    @objc(removeBerthObject:)
    @NSManaged public func removeFromBerth(_ value: Berth)

    @objc(addBerth:)
    @NSManaged public func addToBerth(_ values: NSSet)

    @objc(removeBerth:)
    @NSManaged public func removeFromBerth(_ values: NSSet)

}
