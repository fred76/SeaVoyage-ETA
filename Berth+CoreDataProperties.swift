//
//  Berth+CoreDataProperties.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension Berth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Berth> {
        return NSFetchRequest<Berth>(entityName: "Berth")
    }

    @NSManaged public var berthID: UUID?
    @NSManaged public var berthName: String?
    @NSManaged public var berthDetails: BerthDetail?
    @NSManaged public var locAndEvents: NSSet?
    @NSManaged public var port: Ports?

}

// MARK: Generated accessors for locAndEvents
extension Berth {

    @objc(addLocAndEventsObject:)
    @NSManaged public func addToLocAndEvents(_ value: LocationAndEvents)

    @objc(removeLocAndEventsObject:)
    @NSManaged public func removeFromLocAndEvents(_ value: LocationAndEvents)

    @objc(addLocAndEvents:)
    @NSManaged public func addToLocAndEvents(_ values: NSSet)

    @objc(removeLocAndEvents:)
    @NSManaged public func removeFromLocAndEvents(_ values: NSSet)

}
