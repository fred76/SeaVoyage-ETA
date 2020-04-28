//
//  PilotStations+CoreDataProperties.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension PilotStations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PilotStations> {
        return NSFetchRequest<PilotStations>(entityName: "PilotStations")
    }

    @NSManaged public var idPLT: UUID?
    @NSManaged public var pltName: String?
    @NSManaged public var ports: NSSet?

}

// MARK: Generated accessors for ports
extension PilotStations {

    @objc(addPortsObject:)
    @NSManaged public func addToPorts(_ value: Ports)

    @objc(removePortsObject:)
    @NSManaged public func removeFromPorts(_ value: Ports)

    @objc(addPorts:)
    @NSManaged public func addToPorts(_ values: NSSet)

    @objc(removePorts:)
    @NSManaged public func removeFromPorts(_ values: NSSet)

}
