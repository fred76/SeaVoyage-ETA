//
//  Activity+CoreDataProperties.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var addHFO: Double
    @NSManaged public var addMGO: Double
    @NSManaged public var berthOfActivity: String?
    @NSManaged public var boilerConsuptionPerDay: Double
    @NSManaged public var cargoMoved: Double
    @NSManaged public var distance: Double
    @NSManaged public var duration: Double
    @NSManaged public var eventID: Int16
    @NSManaged public var fixedHFO: Double
    @NSManaged public var fixedMGO: Double
    @NSManaged public var isBoilerHFO: Bool
    @NSManaged public var isBoilerOne: Bool
    @NSManaged public var isBolierThree: Bool
    @NSManaged public var isBolierTwo: Bool
    @NSManaged public var isDDGG_Hfo: Bool
    @NSManaged public var isDDGG_One: Bool
    @NSManaged public var isDDGG_Three: Bool
    @NSManaged public var isDDGG_Two: Bool
    @NSManaged public var isKindOf: Int16
    @NSManaged public var isMaineEngine: Bool
    @NSManaged public var isMeHFO: Bool
    @NSManaged public var speed: Double
    @NSManaged public var vslLaddenPercentage: Double
    @NSManaged public var locationAndEvents: LocationAndEvents?

}
