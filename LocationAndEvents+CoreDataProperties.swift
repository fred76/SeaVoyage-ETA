//
//  LocationAndEvents+CoreDataProperties.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationAndEvents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationAndEvents> {
        return NSFetchRequest<LocationAndEvents>(entityName: "LocationAndEvents")
    }

    @NSManaged public var berth: String?
    @NSManaged public var locationID: Int16
    @NSManaged public var pltStn: String?
    @NSManaged public var port: String?
    @NSManaged public var activity: NSSet?
    @NSManaged public var berths: Berth?
    @NSManaged public var timeZoneForLocation: Double
}

// MARK: Generated accessors for activity
extension LocationAndEvents {

    @objc(addActivityObject:)
    @NSManaged public func addToActivity(_ value: Activity)

    @objc(removeActivityObject:)
    @NSManaged public func removeFromActivity(_ value: Activity)

    @objc(addActivity:)
    @NSManaged public func addToActivity(_ values: NSSet)

    @objc(removeActivity:)
    @NSManaged public func removeFromActivity(_ values: NSSet)

}
