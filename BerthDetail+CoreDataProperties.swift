//
//  BerthDetail+CoreDataProperties.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 10/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension BerthDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BerthDetail> {
        return NSFetchRequest<BerthDetail>(entityName: "BerthDetail")
    }

    @NSManaged public var bunker: Int16
    @NSManaged public var draft: Int16
    @NSManaged public var freshWater: Int16
    @NSManaged public var garbage: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var latitudeDelta: Double
    @NSManaged public var longitude: Double
    @NSManaged public var longitudeDelta: Double
    @NSManaged public var map: Int16
    @NSManaged public var mapScreenshot: Data?
    @NSManaged public var maxDraft: Double
    @NSManaged public var mooringSide: Int16
    @NSManaged public var note: Int16
    @NSManaged public var notetxt: String?
    @NSManaged public var sludge: Int16
    @NSManaged public var stores: Int16
    @NSManaged public var tugsForMooring: Int16
    @NSManaged public var tugsForMooringNumber: Int32
    @NSManaged public var tugsForUnmooring: Int16
    @NSManaged public var tugsForUnmooringNumber: Int32
    @NSManaged public var now: Date?
    @NSManaged public var berth: Berth?
    @NSManaged public var cargoesForBerths: NSSet?

}

// MARK: Generated accessors for cargoesForBerths
extension BerthDetail {

    @objc(addCargoesForBerthsObject:)
    @NSManaged public func addToCargoesForBerths(_ value: CargoesForBerth)

    @objc(removeCargoesForBerthsObject:)
    @NSManaged public func removeFromCargoesForBerths(_ value: CargoesForBerth)

    @objc(addCargoesForBerths:)
    @NSManaged public func addToCargoesForBerths(_ values: NSSet)

    @objc(removeCargoesForBerths:)
    @NSManaged public func removeFromCargoesForBerths(_ values: NSSet)

}
